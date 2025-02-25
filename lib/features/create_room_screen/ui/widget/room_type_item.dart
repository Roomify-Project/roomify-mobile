import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/styles.dart';
import 'custom_generate_container.dart';

class RoomTypeItem extends StatelessWidget {
  const RoomTypeItem({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 70.h,
      width: 100.w,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        // Transparent box
        borderRadius: BorderRadiusDirectional.all(Radius.circular(16.r)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Icon(Icons.ice_skating_sharp,color: Colors.white,size: 29.sp,),
            SizedBox(height: 2.h,),
            Text("living room",style: TextStyles.font14WhiteRegular.copyWith(fontSize: 12.sp),)
          ],
        ),
      ),
    );
  }
}
