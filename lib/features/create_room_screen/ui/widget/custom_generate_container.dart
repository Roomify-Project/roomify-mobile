import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/styles.dart';

class CustomGenerateContainer extends StatelessWidget {
  final double height;
  final double width;
  final String text;
  final IconData? icon;
  final TextStyle style;
  final BorderRadiusGeometry borderRadius; // إضافة متغير borderRadius
  final BorderRadiusDirectional?
      borderRadiusDirectional; // إضافة متغير borderRadius

  const CustomGenerateContainer({
    super.key,
    this.height = 90,
    this.width = 80,
    this.borderRadius = BorderRadius.zero,
    this.borderRadiusDirectional = BorderRadiusDirectional.zero,
    required this.text, this.icon, required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      width: width.w,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        // Transparent box
        borderRadius: borderRadius == BorderRadius.zero
            ? borderRadiusDirectional
            : borderRadius,
      ),
      child: Column(
        children: [
          icon!=null? SizedBox(height: 10.h,):const SizedBox(),
         icon!=null?Icon(icon,size: 37.sp,color: Colors.white,):const SizedBox(),
          SizedBox(height: 4.h,),
          Center(child: Text(text, style: style)),
        ],
      ),
    );
  }
}
