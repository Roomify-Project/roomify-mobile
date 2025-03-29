import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rommify_app/features/room_types_screen/ui/room_types.dart';
import '../../../../core/theming/colors.dart';

class RoomType extends StatelessWidget {
  const RoomType({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierColor: Colors.transparent,
          builder: (context) => const RoomTypeScreen(),
        );
      },
      child: Container(
        width: double.infinity,
        height: 77.h,
        decoration: BoxDecoration(
          color: ColorsManager.colorContainer,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(12.r),
            bottomLeft: Radius.circular(12.r),
            topRight: Radius.circular(12.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 35.w,
              height: 35.h,
              decoration: BoxDecoration(
                color: ColorsManager.colorContainer,
                shape: BoxShape.circle,
                border: Border.all(
                  color: ColorsManager.colorCircle,
                  width: 3,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: SvgPicture.asset(
                  'assets/images/pin.svg',
                  color: ColorsManager.colorCircle,
                  height: 12.h,
                  width: 12.w,
                ),
              ),
            ),
            Text(
              "Add room images",
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
