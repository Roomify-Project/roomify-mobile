// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../theming/colors.dart';

// class AppTextButton extends StatelessWidget {
//   final double? borderRadius;
//   final Color? backgroundColor;
//   final double? horizontalPadding;
//   final double? verticalPadding;
//   final double? buttonWidth;
//   final double? buttonHeight;
//   final String buttonText;
//   final TextStyle textStyle;
//   final VoidCallback onPressed;
//   const AppTextButton({
//     super.key,
//     this.borderRadius,
//     this.backgroundColor,
//     this.horizontalPadding,
//     this.verticalPadding,
//     this.buttonHeight,
//     this.buttonWidth,
//     required this.buttonText,
//     required this.textStyle,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       style: ButtonStyle(
//         shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//           RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(borderRadius ?? 16.0),
//           ),
//         ),
//         backgroundColor: WidgetStatePropertyAll(
//           backgroundColor ?? ColorsManager.mainBurble,
//         ),
//         padding: WidgetStateProperty.all<EdgeInsets>(
//           EdgeInsets.symmetric(
//             horizontal: horizontalPadding?.w ?? 12.w,
//             vertical: verticalPadding?.h ?? 14.h,
//           ),
//         ),
//         fixedSize: WidgetStateProperty.all(
//           Size(buttonWidth?.w ?? double.maxFinite, buttonHeight ?? 50.h),
//         ),
//       ),
//       onPressed: onPressed,
//       child: Text(
//         buttonText,
//         style: textStyle,
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';

class ColorChangingButton extends StatefulWidget {
  final String buttonText; // النص المتغير داخل الزر
  final VoidCallback? onPressed; // دالة يتم استدعاؤها عند الضغط على الزر

  const ColorChangingButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<ColorChangingButton> createState() => _ColorChangingButtonState();
}

class _ColorChangingButtonState extends State<ColorChangingButton> {
  // قائمة الألوان التي سيتغير بينها الزر
  List<Color> colors = [
    const Color(0xFF481837),
    const Color(0xFF1B1848),
    const Color(0xFF483918),
    const Color(0xFF1C4818),
    const Color(0xFF183648),
    const Color(0xFF481818),
  ];

  int currentColorIndex = 0;
  Timer? _timer; // تعريف الـ Timer

  @override
  void initState() {
    super.initState();
    // بدء تغيير الألوان بشكل دوري
    _startColorChange();
  }

  // دالة لتغيير الألوان بشكل دوري
  void _startColorChange() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) { // التحقق من أن الـ Widget ما زال موجودًا في الشجرة
        setState(() {
          currentColorIndex = (currentColorIndex + 1) % colors.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // إيقاف الـ Timer عند التخلص من الـ Widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed, // استدعاء الدالة عند الضغط
      child: AnimatedContainer(
        duration: const Duration(seconds: 1), // تحديد مدة الأنيميشن
        curve: Curves.easeInOut, // نوع الحركة (يمكنك تعديله حسب تفضيلك)
        width: 108.97, // العرض
        height: 34.51, // الطول
        decoration: BoxDecoration(
          color: colors[currentColorIndex],
          borderRadius: BorderRadius.circular(71),
        ),
        child: Center(
          child: Text(
            widget.buttonText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
