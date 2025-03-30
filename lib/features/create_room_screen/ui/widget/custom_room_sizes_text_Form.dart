import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';

class CustomRoomSizesTextForm extends StatelessWidget {
  const CustomRoomSizesTextForm({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 31.h,
      width: 81.w,
      decoration: BoxDecoration(
        color: ColorsManager.colorContainer,
      ),
      child: Center( // إضافة Center widget
        child: TextField(
          textAlign: TextAlign.center,
          // controller: lengthController,
          decoration: InputDecoration(
            isCollapsed: true, // لإزالة الـ padding الافتراضي
            contentPadding: EdgeInsets.zero, // لإزالة المسافات الداخلية
            hintText: 'length',
            hintStyle: TextStyles.font12WhiteRegular,
            border: InputBorder.none,
          ),
          style: TextStyles.font12WhiteRegular, // لتنسيق النص المدخل
        ),
      ),
    );
  }
}
