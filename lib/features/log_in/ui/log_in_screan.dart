import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/theming/colors.dart';
import 'package:rommify_app/core/widgets/animated_bottom_right.dart';
import 'package:rommify_app/core/widgets/animated_text_widget.dart';
import 'package:rommify_app/core/widgets/app_text_button.dart';
import 'package:rommify_app/core/widgets/app_text_form_field.dart';
import 'package:rommify_app/core/widgets/google_icon.dart';
import 'package:rommify_app/core/widgets/or_driver.dart';
import 'package:rommify_app/features/log_in/ui/widget/don/dont_have_account.dart';
import 'package:rommify_app/features/profile/profile.dart';

class LogInScrean extends StatelessWidget {
  const LogInScrean({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.colorPrimary,
      body: SafeArea(
        child: Stack(
          children: [
            const StaticGradientBeam(),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 157.w, top: 68.h),
                    child: const AnimatedText(text: 'Log In'),
                  ),
                  SizedBox(height: 20.h),
                  const SingupRichText(),
                  SizedBox(height: 67.h),
                  Center(child: GoogleIcon()),
                  SizedBox(height: 47.42.h),
                  OrDivider(),
                  SizedBox(height: 97.16.h),
                  CustomTextFormField(
                    labelText: 'Email',
                    controller: TextEditingController(),
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 67.h),
                  CustomTextFormField(
                    labelText: 'Password',
                    controller: TextEditingController(),
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 213, bottom: 60),
                    child: Center(
                        child: ColorChangingButton(
                      buttonText: "Log In",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen()));
                      },
                    )),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
