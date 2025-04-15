import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SingupRichText extends StatelessWidget {
  final VoidCallback? onLoginTap;

  const SingupRichText({Key? key, this.onLoginTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Don't have an account? ",
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
          children: [
            TextSpan(
              text: "Sign up",
              style: TextStyle(color: Colors.red, fontSize: 18.sp),
              recognizer: TapGestureRecognizer()..onTap = onLoginTap,
            ),
          ],
        ),
      ),
    );
  }
}
