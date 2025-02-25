import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/theming/colors.dart';

import '../../../core/theming/styles.dart';
import '../../create_room_screen/ui/widget/circle_widget.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.colorPrimary,
      body: Stack(
        children: [
          CircleWidget(),
          Column(
            children: [
              SizedBox(
                height: 60.h,
              ),
              Container(
                width: double.infinity.w,
                height: 300.h,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadiusDirectional.circular(14.r),
                ),
                child: const Image(
                  image: NetworkImage(
                    'https://th.bing.com/th/id/OIP.9nl2eFOD4SKNC_FIn0bSqQHaFj?rs=1&pid=ImgDetMain',
                  ),
                  fit: BoxFit.cover,
                  height: 300,
                ),
              ),
              SizedBox(
                height: 29.h,
              ),
              Padding(
                padding:  EdgeInsets.only(left: 47.w),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30.r,
                      backgroundImage: const NetworkImage(
                          'https://th.bing.com/th/id/OIP.9nl2eFOD4SKNC_FIn0bSqQHaFj?rs=1&pid=ImgDetMain'),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ANTONEOS",
                          style: TextStyles.font19WhiteBold,
                        ),
                        Text(
                          "Interior Designer",
                          style: TextStyles.font15WhiteRegular,
                        ),
                        Text(
                          "@aliellebi123",
                          style: TextStyles.font15WhiteRegular
                              .copyWith(fontSize: 11.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h,),
              Container(
                width: 311.w,
                height: 67.h,
                decoration: BoxDecoration(
                  color: const Color(0xff767676),
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x7676764A),
                      blurRadius: 25.0,
                      spreadRadius: 0.0,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: Center(child: Text("good",style:TextStyles.font21BlackSemiBold.copyWith(fontWeight: FontWeight.w700,fontSize: 20.sp,color: Colors.white) ,)),
              ),
              const Spacer(),
              Container(
                width: 376.w,
                height: 74.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  color: const Color(0xffA9631D),
                ),
                child: Center(child: Text("comment....",style: TextStyles.font24WhiteExtraBold,)),
              ),
              SizedBox(height: 20.h,),

            ],
          ),
        ],
      ),
    );
  }
}
