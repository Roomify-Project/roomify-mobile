import 'dart:async';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rommify_app/core/routing/routes.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../core/helpers/constans.dart';
import '../../../../core/helpers/shared_pref_helper.dart';
import '../../../../core/networking/api_networking.dart';

class NotificationSignalRService {
  static HubConnection? _connection;
  static final StreamController<String> _notificationController =
  StreamController<String>.broadcast();

  static final StreamController<Map<String, dynamic>> _notificationAPController =
  StreamController<Map<String, dynamic>>.broadcast();

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static bool isConnected = false;
  static int _retryCount = 0;
  static const int maxRetries = 3;

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
        });
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification clicked while app in background.");
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
          final data = jsonDecode(response.payload!);
          final type = data['type'];

          switch (type) {
            case 'chat':
              final chatId = data['chatId'];
              Constants.navigatorKey.currentState?.pushNamed(
                Routes.chatsFriendsScreen,
                arguments: chatId,
              );
              break;
            case 'follow':
              final userId = data['userId'];
              Constants.navigatorKey.currentState?.pushNamed(
                Routes.profile,
                arguments: {
                  'profileId':userId
                },
              );
              break;
            case 'comment':
              final postId = data['postId'];
              Constants.navigatorKey.currentState?.pushNamed(
                Routes.mainScreen,
                arguments: {
                  'postId':postId
                },
              );
              break;
            default:
              Constants.navigatorKey.currentState?.pushNamed(Routes.notification);
              break;
          }

          print("Notification tapped with data: $data");
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

    await startConnection();
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

        _connection?.on('ReceiveNotification', (data) {
          if (data != null && data.isNotEmpty) {
            handleReceivedData(data);
          }
        });

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

  static Stream<String> get notificationStream => _notificationController.stream;
  static Stream<Map<String, dynamic>> get apiNotificationStream => _notificationAPController.stream;

  static Future<void> _showNotification(Map<String, dynamic> data) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
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

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    final message = data['message'] ?? 'New Notification';

    await _notificationsPlugin.show(
      0,
      'New Notification',
      message,
      platformDetails,
      payload: jsonEncode(data),
    );
  }

  static void dispose() {
    _notificationController.close();
    _notificationAPController.close();
    _connection?.stop();
  }
}
