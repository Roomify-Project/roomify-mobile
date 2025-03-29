
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rommify_app/core/theming/colors.dart';

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
              Expanded(
                child: Padding(
                  padding:  EdgeInsets.only(left: 23.w,right: 23.w,top: 89.h),
                  child: const CustomGirdView(),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
