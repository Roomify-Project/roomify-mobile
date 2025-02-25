import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/routing/routes.dart';

import 'core/routing/app_router.dart';

class RoomifyApp extends StatelessWidget {
  final AppRouter appRouter;

  const RoomifyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(402, 874),
      minTextAdapt: true,
      child: MaterialApp(
        title: 'RoomifyApp',
        theme: ThemeData(

            // primaryColor: ColorsManager.white,
            // scaffoldBackgroundColor: ColorsManager.white,
            // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            // useMaterial3: true,

            ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: appRouter.generateRoute,
        initialRoute: Routes.signUpScreen,
      ),
    );
  }
}
