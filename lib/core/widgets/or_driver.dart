import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // محاذاة العناصر في الوسط
        children: [
          // الخط الأول
          Expanded(
            child: Divider(
              color: Color(0xFFFFFFFF), // لون الخط
              thickness: .5, // سمك الخط
              indent: 2.w, // المسافة من اليسار إلى بداية الخط
              endIndent: 6.5.w, // المسافة من نهاية الخط إلى "OR"
            ),
          ),
          // كلمة "OR"
          Text(
            'OR',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.5.sp,
                fontWeight: FontWeight.w900),
          ),
          // الخط الثاني
          Expanded(
            child: Divider(
              color: Colors.white, // لون الخط
              thickness: .5, // سمك الخط
              indent: 6.5.w, // المسافة من بداية الخط إلى "OR"
              endIndent: 2.w, // المسافة من نهاية الخط
            ),
          ),
        ],
      ),
    );
  }
}
