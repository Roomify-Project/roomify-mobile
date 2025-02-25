import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/routing/app_router.dart';
import 'package:rommify_app/main_rommify.dart';

import 'core/helpers/shared_pref_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await SharedPrefHelper.init();
  runApp( RoomifyApp(appRouter: AppRouter(),));
}
