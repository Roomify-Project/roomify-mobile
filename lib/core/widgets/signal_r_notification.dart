import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:rommify_app/core/routing/routes.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../../../../core/helpers/constans.dart';
import '../../../../core/helpers/shared_pref_helper.dart';
import '../../../../core/networking/api_networking.dart';
import '../../features/profile/data/models/get_profile_data.dart';
import '../helpers/firebase_information.dart';

class NotificationSignalRService {
  static HubConnection? _connection;
  static final StreamController<String> _notificationController =
      StreamController<String>.broadcast();

  static final StreamController<Map<String, dynamic>>
      _notificationAPController =
      StreamController<Map<String, dynamic>>.broadcast();

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool isConnected = false;
  static int _retryCount = 0;
  static const int maxRetries = 3;

  // Cache للـ Access Token
  static String? _cachedAccessToken;
  static DateTime? _tokenExpiry;

  // HTTP Client للـ connection pooling
  static final http.Client _httpClient = http.Client();

  // Cache للـ FCM Tokens
  static final Map<String, String> _fcmTokenCache = {};
  static final Map<String, DateTime> _fcmTokenCacheExpiry = {};

  static Future<void> initializeConnection() async {
    await _initSignalRConnection();
  }

  static Future<void> _initFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    String? token = await messaging.getToken();
    print("FCM Token: $token");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showNotification({
          "type": "general",
          "message": message.notification!.body ?? "New Message",
          "title": message.notification!.title ?? "New Notification",
        });
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          "Notification clicked while app in background .${message.notification!.title}");
      if (message.notification!.body!.contains('commented')) {
        print("yessssssssssss commment");
        Constants.navigatorKey.currentState?.pushNamed(
          Routes.mainScreen,
          arguments: {'postId': message.data['postId']},
        );
      } else if (message.notification!.body!.contains('following')) {
        Constants.navigatorKey.currentState?.pushNamed(
          Routes.profile,
          arguments: {
            'profileId': SharedPrefHelper.getString(SharedPrefKey.userId)
          },
        );
      } else {
        print("messsageeeee");
        Constants.navigatorKey.currentState?.pushNamed(
          Routes.chatsFriendsScreen,
          arguments: {
            'getProfileDataModel': GetProfileDataModel(
                id: message.data['chatId'],
                userName: message.data['userName'],
                fullName: message.data['userName'],
                bio: message.data['bio'],
                email:message.data['email'],
                role: message.data['role'],
                emailConfirmed:true,
            profilePicture:  message.data['userImage']
            )

          },
        );
      }
    });
  }

  static Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          // final data = jsonDecode(response.payload!);
          // final type = data['type'];
          //
          // switch (type) {
          //   case 'chat':
          //     final chatId = data['chatId'];
          //     Constants.navigatorKey.currentState?.pushNamed(
          //       Routes.chatsFriendsScreen,
          //       arguments: chatId,
          //     );
          //     break;
          //   case 'follow':
          //     final userId = data['userId'];
          //     Constants.navigatorKey.currentState?.pushNamed(
          //       Routes.profile,
          //       arguments: {'profileId': userId},
          //     );
          //     break;
          //   case 'comment':
          //     final postId = data['postId'];
          //     Constants.navigatorKey.currentState?.pushNamed(
          //       Routes.mainScreen,
          //       arguments: {'postId': postId},
          //     );
          //     break;
          //   default:
          //     Constants.navigatorKey.currentState
          //         ?.pushNamed(Routes.notification);
          //     break;
          // }

          // print("Notification tapped with data: $data");
        }
      },
    );
  }

  static Future<void> _initSignalRConnection() async {
    _connection = HubConnectionBuilder()
        .withUrl("${ApiConstants.apiBaseUrl}/notificationHub",
            options: HttpConnectionOptions(
              skipNegotiation: false,
              transport: HttpTransportType.WebSockets,
              accessTokenFactory: () async =>
                  await SharedPrefHelper.getString(SharedPrefKey.token),
            ))
        .withAutomaticReconnect()
        .build();

    // await startConnection();
    await _initLocalNotifications();
    await _initFCM();
  }

  static Future<void> startConnection() async {
    try {
      if (_connection?.state == HubConnectionState.Disconnected) {
        await _connection?.start()?.timeout(
              const Duration(seconds: 20),
              onTimeout: () => throw 'Connection timeout',
            );

        isConnected = true;
        _retryCount = 0;

        // _connection?.on('ReceiveNotification', (data) {
        //   if (data != null && data.isNotEmpty) {
        //     handleReceivedData(data);
        //   }
        // });

        _connection?.onclose(({error}) async {
          isConnected = false;
          print('SignalR disconnected: $error');
          await Future.delayed(const Duration(seconds: 2));
          await startConnection();
        });

        print("SignalR connected successfully.");
      }
    } catch (error) {
      print('SignalR connection error: $error');
      if (_retryCount >= maxRetries) {
        print('Max retries reached. Could not connect.');
        return;
      }
      await Future.delayed(const Duration(seconds: 2));
      _retryCount++;
      await startConnection();
    }
  }

  static void handleReceivedData(dynamic data) {
    try {
      if (data is List) {
        print("Received list data: ${data[0]['message']}");
        _showNotification(data[0]);
        processItem(data[0]);
      } else if (data is Map<String, dynamic>) {
        print("Received map data: ${data['message']}");
        _showNotification(data);
        processItem(data);
      } else {
        print('Unknown data format.');
      }
    } catch (error) {
      print('Error handling received data: $error');
    }
  }

  static void processItem(dynamic item) {
    try {
      if (item is Map<String, dynamic>) {
        _notificationAPController.add(item);
        print("Item added to notification stream.");
      } else {
        print("Unsupported item format.");
      }
    } catch (error) {
      print('Error processing item: $error');
    }
  }

  static Stream<String> get notificationStream =>
      _notificationController.stream;

  static Stream<Map<String, dynamic>> get apiNotificationStream =>
      _notificationAPController.stream;

  static Future<void> _showNotification(Map<String, dynamic> data) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel',
      'Notifications',
      channelDescription: 'App notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
      enableVibration: true,
      icon: 'ic_stat_notification',
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    final message = data['message'] ?? 'New Notification';

    await _notificationsPlugin.show(
      0,
      data['title'],
      message,
      platformDetails,
      payload: jsonEncode(data),
    );
  }

  // محسن: Access Token مع Cache
  static Future<String> getAccessToken() async {
    // تحقق من وجود token صالح في الـ cache
    if (_cachedAccessToken != null &&
        _tokenExpiry != null &&
        DateTime.now()
            .isBefore(_tokenExpiry!.subtract(const Duration(minutes: 5)))) {
      return _cachedAccessToken!;
    }

    try {
      final accountCredentials =
          ServiceAccountCredentials.fromJson(serviceAccountJson);
      final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

      final authClient =
          await clientViaServiceAccount(accountCredentials, scopes);

      _cachedAccessToken = authClient.credentials.accessToken.data;
      _tokenExpiry = authClient.credentials.accessToken.expiry;

      return _cachedAccessToken!;
    } catch (e) {
      print('Error getting access token: $e');
      rethrow;
    }
  }

  // محسن: FCM Token مع Cache
  static Future<String?> _getFCMToken(String userId) async {
    // تحقق من الـ cache أولاً
    if (_fcmTokenCache.containsKey(userId)) {
      final expiry = _fcmTokenCacheExpiry[userId];
      if (expiry != null && DateTime.now().isBefore(expiry)) {
        return _fcmTokenCache[userId];
      }
    }

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .timeout(const Duration(seconds: 5)); // Timeout للتحكم في البطء

      if (!userDoc.exists) {
        print('❌ User document not found');
        return null;
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final String? fcmToken = userData['fcmToken'];

      if (fcmToken != null && fcmToken.isNotEmpty) {
        // احفظ في الـ cache لمدة 30 دقيقة
        _fcmTokenCache[userId] = fcmToken;
        _fcmTokenCacheExpiry[userId] =
            DateTime.now().add(Duration(minutes: 30));
        return fcmToken;
      }

      return null;
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  // محسن: إرسال الإشعارات بشكل أسرع
  static Future<bool> sendPushNotification({
    required String title,
    required String body,
    required String userId,
    String? postId,
    String? userName,
    String? image,
    String? chatId,
    String? userImage,
    String? role,
    String? bio,
    String? email,
    String? messageId, // أضف هذا المعامل
    bool isUpdate = false, // أضف هذا المعامل
    Map<String, String>? additionalData,
  }) async {
    try {
      // 1. الحصول على FCM Token (مع cache)
      final String? fcmToken = await _getFCMToken(userId);
      if (fcmToken == null) {
        print('❌ FCM token not found for user: $userId');
        return false;
      }

      // 2. الحصول على Access Token (مع cache)
      final String accessToken = await getAccessToken();
      const String projectId = "roomify-beb04";

      // 3. بناء الـ payload مع إضافة معرف النوتيفيكيشن
      final Map<String, dynamic> notificationPayload = {
        "message": {
          "token": fcmToken,
          "notification": {
            "title": title,
            "body": body,
            "image":image,
          },
          "data": {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "status": "done",
            "userId": userId,
            'postId': postId,
            'chatId': chatId,
            "userName": userName,
            "userImage": userImage,
            "role": role,
            "bio": bio,
            "email": email,
            "messageId": messageId, // معرف الرسالة
            "isUpdate": isUpdate.toString(), // علشان نعرف إن دي تحديث
            ...?additionalData,
          },
          "android": {
            "priority": "high",
            "notification": {
              "sound": "default",
              "channel_id": "high_importance_channel",
              // أضف tag عشان Android يستبدل النوتيفيكيشن بدلاً من إضافة واحدة جديدة
              "tag": messageId ?? chatId ?? "default_tag",
            }
          },
          "apns": {
            "payload": {
              "aps": {
                "sound": "default",
                "badge": 1,
                // بالنسبة لـ iOS، thread-id بيخلي النوتيفيكيشنز تتجمع
                "thread-id": chatId ?? "default_thread"
              }
            }
          }
        }
      };

      // 4. إرسال الطلب مع timeout قصير
      final response = await _httpClient
          .post(
            Uri.parse(
                'https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode(notificationPayload),
          )
          .timeout(const Duration(seconds: 10)); // Timeout 10 ثواني

      if (response.statusCode == 200) {
        print('✅ Notification sent successfully to user: $userId');
        return true;
      } else {
        print('❌ Failed to send notification. Status: ${response.statusCode}');
        print('Response: ${response.body}');

        // إذا كان الـ token منتهي الصلاحية، امسح الـ cache
        if (response.statusCode == 401) {
          _cachedAccessToken = null;
          _tokenExpiry = null;
        }

        return false;
      }
    } catch (e) {
      print('🔥 Error sending notification: $e');
      return false;
    }
  }

  // إرسال متوازي لعدة مستخدمين (أسرع)
  static Future<List<bool>> sendNotificationToMultipleUsers({
    required String title,
    required String body,
    required List<String> userIds,
    Map<String, String>? additionalData,
  }) async {
    // إرسال متوازي بدلاً من متتالي
    final List<Future<bool>> futures = userIds
        .map((userId) => sendPushNotification(
              title: title,
              body: body,
              userId: userId,
              additionalData: additionalData,
            ))
        .toList();

    try {
      // انتظار جميع الطلبات مع timeout
      final results = await Future.wait(
        futures,
        eagerError: false, // لا تتوقف عند أول خطأ
      ).timeout(const Duration(seconds: 30));

      final successCount = results.where((result) => result).length;
      print('✅ Sent notifications to $successCount/${userIds.length} users');

      return results;
    } catch (e) {
      print('🔥 Error in batch notification: $e');
      return List.filled(userIds.length, false);
    }
  }

  // تنظيف الـ cache دورياً
  static void clearExpiredCache() {
    final now = DateTime.now();

    // تنظيف FCM token cache
    _fcmTokenCacheExpiry.removeWhere((key, expiry) {
      if (now.isAfter(expiry)) {
        _fcmTokenCache.remove(key);
        return true;
      }
      return false;
    });
  }

  static void dispose() {
    _notificationController.close();
    _notificationAPController.close();
    _connection?.stop();
    _httpClient.close();

    // تنظيف الـ cache
    _fcmTokenCache.clear();
    _fcmTokenCacheExpiry.clear();
    _cachedAccessToken = null;
    _tokenExpiry = null;
  }
}
