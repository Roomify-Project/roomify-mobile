import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginRichText extends StatelessWidget {
  final VoidCallback? onLoginTap;

  const LoginRichText({Key? key, this.onLoginTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Already have an account? ",
          style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800),
          children: [
            TextSpan(
              text: "Login",
              style: TextStyle(
                  color: const Color(0xffE11515),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800),
              recognizer: TapGestureRecognizer()..onTap = onLoginTap,
            ),
          ],
        ),
      ),
    );
  }
}
