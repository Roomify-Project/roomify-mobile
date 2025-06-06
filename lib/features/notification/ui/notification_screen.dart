import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rommify_app/core/theming/colors.dart';
import 'package:rommify_app/core/widgets/custom_shimmer.dart';
import 'package:rommify_app/features/notification/data/repo/notification_repo.dart';
import 'package:rommify_app/features/notification/logic/cubit/notification_states.dart';
import 'package:rommify_app/features/notification/logic/cubit/notiication_cubit.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/theming/styles.dart';
import '../../../core/widgets/custom_empity_list.dart';
import '../../../core/widgets/custom_error.dart';
import '../../create_room_screen/ui/widget/circle_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          NotificationCubit(getIt.get<NotificationRepo>())
            ..getAllNotification(),
      child: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (BuildContext context, state) {
          final notification = NotificationCubit.get(context);
          return Stack(
            children: [
              CircleWidget(),
              state is NotificationLoading
                  ? Scaffold(
                      backgroundColor: ColorsManager.colorPrimary,
                      body: Padding(
                        padding: EdgeInsets.only(top: 50.h),
                        child: const CustomShimmerEffect(),
                      ),
                    )
                  : state is GetNotificationError
                      ? Scaffold(
                          backgroundColor: ColorsManager.colorPrimary,
                          body: Center(
                            child: AnimatedErrorWidget(
                              title: "Loading Error",
                              message: state.message ?? "No data available",
                              lottieAnimationPath:
                                  'assets/animation/error.json',
                              // onRetry: () => postsCubit.getAllPosts(),
                            ),
                          ),
                        )
                      : (notification.notificationModel!.notificationData
                                  .isEmpty ||
                              notification.notificationModel == null)
                          ? const Scaffold(
                              backgroundColor: ColorsManager.colorPrimary,
                              body: Center(
                                child: AnimatedEmptyList(
                                  title: "No Notificatiom Found",
                                  lottieAnimationPath:
                                      'assets/animation/empity_list.json',
                                ),
                              ),
                            )
                          : Scaffold(
                              backgroundColor: ColorsManager.colorPrimary,
                              body: SafeArea(
                                child: Padding(
                                  padding:  EdgeInsets.only(
                                      top: 85.h,right: 23.w,left: 23.w),
                                  child: ListView.separated(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: notification.notificationModel!
                                        .notificationData.length,
                                    itemBuilder: (context, index) {
                                      final notificationItem = notification
                                          .notificationModel!
                                          .notificationData[index];
                                      DateTime dateTime = DateTime.parse(
                                          notificationItem.createdAt);

                                      // نحول الوقت لشكل 12 ساعة مع AM/PM
                                      String formattedTime =
                                          DateFormat('hh:mm a').format(dateTime);
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: RichText(
                                              text: TextSpan(
                                                children: _buildStyledText(
                                                    notificationItem.message),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            formattedTime,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white54),
                                          ),
                                        ],
                                      );
                                    }, separatorBuilder: (BuildContext context, int index) {
                                      return SizedBox(height: 23.h,);
                                  },
                                  ),
                                ),
                              ),
                            ),
            ],
          );
        },
      ),
    );
  }
}

List<TextSpan> _buildStyledText(String message) {
  final spans = <TextSpan>[];

  if (message.startsWith("@")) {
    final parts = message.split(" ");
    if (parts.isNotEmpty) {
      spans.add(
          TextSpan(text: "${parts[0]} ", style: TextStyles.font16WhiteBold));
      spans.add(TextSpan(text: message.substring(parts[0].length + 1)));
    } else {
      spans.add(TextSpan(text: message));
    }
  } else {
    spans.add(TextSpan(text: message));
  }

  return spans;
}
