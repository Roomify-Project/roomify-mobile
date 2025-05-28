import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:rommify_app/core/routing/app_router.dart';
import 'package:rommify_app/main_rommify.dart';

import 'core/di/dependency_injection.dart';
import 'core/helpers/shared_pref_helper.dart';
import 'core/widgets/check_server_connection.dart';

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrintStack(label: '⚠️ Widget context warning stack trace:', stackTrace: details.stack);
  };
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await SharedPrefHelper.init();
  await setupGetIt();
  await CheckServerConnection.checkServerConnection();
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
  runApp(RoomifyApp(appRouter: AppRouter(),));
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
