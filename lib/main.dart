import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:rommify_app/core/routing/app_router.dart';
import 'package:rommify_app/main_rommify.dart';

import 'core/di/dependency_injection.dart';
import 'core/helpers/shared_pref_helper.dart';
import 'core/widgets/check_server_connection.dart';
import 'core/widgets/signal_r_notification.dart';
import 'firebase_options.dart';

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrintStack(label: '⚠️ Widget context warning stack trace:', stackTrace: details.stack);
  };
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await SharedPrefHelper.init();
  await setupGetIt();
  // await CheckServerConnection.checkServerConnection();
  // await CheckServerNotificationConnection.checkServerNotificationConnection();

  final status = await Permission.notification.status;
  _requestNotificationPermission();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Permission permission;


  if (Platform.isAndroid) {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    if (deviceInfo.version.sdkInt >= 33) {
      // Android 13+ uses granular media permissions
      permission = Permission.photos;
    } else {
      // Android 12 and below
      permission = Permission.storage;
    }
  } else {
    // iOS
    permission = Permission.photos;
  }

  configLoading();
  runApp(  EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('ar')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    startLocale: const Locale('ar'), // اللغة الافتراضية
    child: RoomifyApp(appRouter: AppRouter(),),
  )
  );
}
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

Future<void> _requestNotificationPermission() async {
  if (Platform.isAndroid) {
    // Android 13+ only
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      final result = await Permission.notification.request();
      if (!result.isGranted) {
        // المستخدم رفض الصلاحية، ممكن تنبهه برسالة
        debugPrint('Notification permission denied');
      }
    }
  }
}

