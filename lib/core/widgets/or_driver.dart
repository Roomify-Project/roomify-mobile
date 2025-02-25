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
              thickness: 1.0, // سمك الخط
              indent: 0, // المسافة من اليسار إلى بداية الخط
              endIndent: 6.5.w, // المسافة من نهاية الخط إلى "OR"
            ),
          ),
          // كلمة "OR"
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 6.5), // المسافة حول النص
            child: Text(
              'OR',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          // الخط الثاني
          Expanded(
            child: Divider(
              color: Colors.white, // لون الخط
              thickness: 1.0, // سمك الخط
              indent: 6.5.w, // المسافة من بداية الخط إلى "OR"
              endIndent: 0, // المسافة من نهاية الخط
            ),
          ),
        ],
      ),
    );
  }
}
