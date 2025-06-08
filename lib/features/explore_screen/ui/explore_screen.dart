
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rommify_app/core/di/dependency_injection.dart';
import 'package:rommify_app/core/helpers/extensions.dart';
import 'package:rommify_app/core/routing/app_router.dart';
import 'package:rommify_app/core/routing/routes.dart';

import 'package:rommify_app/core/theming/colors.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/posts_cubit.dart';
import 'package:rommify_app/features/explore_screen/ui/widget/custom_grid_view_explore.dart';

import '../../../core/theming/styles.dart';
import '../../../core/widgets/custom_gird_view.dart';
import '../../create_room_screen/ui/widget/circle_widget.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.colorPrimary,
      body: Stack(
        children: [
          CircleWidget(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    SizedBox(height: 80.h,),
                    Text("EXPLORE",style: TextStyles.font10WhiteBold,),
                    const Spacer(),
                    SvgPicture.asset('assets/images/search.svg',height: 20.h,width: 20.w,),
                    SizedBox(width: 10.w,),
                    InkWell(
                        onTap: () {
                          context.pushNamed(Routes.chatsScreen,
                          );
                        },
                        child: SvgPicture.asset('assets/images/chat.svg',height: 20.h,width: 20.w,)),
                    SizedBox(width: 10.w,),
                    InkWell(
                        onTap: () {
                          context.pushNamed(Routes.notification);
                        },
                        child: SvgPicture.asset('assets/images/notification.svg',height: 20.h,width: 20.w,))

                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding:  EdgeInsets.only(left: 23.w,right: 23.w),
                  child:  const CustomGridViewExplore(),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
