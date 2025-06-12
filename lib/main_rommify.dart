import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/helpers/constans.dart';
import 'package:rommify_app/core/routing/routes.dart';
import 'package:rommify_app/features/chat/data/repos/chat_repo.dart';
import 'package:rommify_app/features/chat/logic/cubit/chat_cubit.dart';
import 'package:rommify_app/features/explore_screen/data/repos/posts_repo.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/posts_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/di/dependency_injection.dart';
import 'core/helpers/shared_pref_helper.dart';
import 'core/routing/app_router.dart';
import 'features/create_room_screen/ui/widget/circle_widget.dart';
import 'features/log_in/data/repos/login_repo.dart';
import 'features/notification/logic/cubit/notiication_cubit.dart';

class RoomifyApp extends StatelessWidget {
  final AppRouter appRouter;

  const RoomifyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        // BlocProvider<NotificationCubit>(
        //   create: (context) => NotificationCubit()..initializeNotifications(),
        // ),
        BlocProvider(create: (context) => PostsCubit(getIt.get<PostsRepo>())),
        BlocProvider(create: (context) => ChatCubit(getIt.get<ChatRepo>()))

      ],
      child: ScreenUtilInit(
        designSize: const Size(402, 874),
        minTextAdapt: true,
        child: MaterialApp(
          navigatorKey: Constants.navigatorKey,
          title: 'RoomifyApp',
          builder: (context, child) {
            return Stack(
              children: [
                EasyLoading.init()(context, child), // مهم
                 // IgnorePointer(
                 //   ignoring: true,
                 //   child: CircleWidget(),
                 // ),
              ],
            );
          },
          theme: ThemeData(
              // primaryColor: ColorsManager.white,
              // scaffoldBackgroundColor: ColorsManager.white,
              // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              // useMaterial3: true,
              ),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: appRouter.generateRoute,
          initialRoute:SharedPrefHelper.getString('token')!=null?Routes.navBar: Routes.loginScreen,
        ),
      ),
    );
  }
}
