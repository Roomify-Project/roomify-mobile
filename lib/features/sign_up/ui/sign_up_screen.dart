import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/helpers/extensions.dart';
import 'package:rommify_app/core/routing/routes.dart';
import 'package:rommify_app/core/theming/colors.dart';
import 'package:rommify_app/core/widgets/animated_bottom_right.dart';
import 'package:rommify_app/core/widgets/animated_text_widget.dart';
import 'package:rommify_app/core/widgets/app_text_button.dart';
import 'package:rommify_app/core/widgets/app_text_form_field.dart';
import 'package:rommify_app/core/widgets/google_icon.dart';
import 'package:rommify_app/core/widgets/or_driver.dart';
import 'package:rommify_app/features/log_in/ui/log_in_screan.dart';

import 'package:rommify_app/features/sign_up/ui/widget/aready_have_account_text.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.mainColor,
      body: SafeArea(
        child: Stack(
          children: [
            StaticGradientBeam(),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 157.w, top: 50.h),
                    child: const AnimatedText(text: 'Sign Up'),
                  ),
                  LoginRichText(
                    onLoginTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LogInScrean()));
                    },
                  ),
                  SizedBox(height: 44.h),
                  Center(child: GoogleIcon()),
                  SizedBox(height: 47.42.h),
                  OrDivider(),
                  SizedBox(height: 61.16.h),
                  CustomTextFormField(
                    labelText: 'Full Name',
                    controller: TextEditingController(),
                    obscureText: false,
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(height: 18.h),
                  CustomTextFormField(
                    labelText: 'Username',
                    controller: TextEditingController(),
                    obscureText: false,
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(height: 18.h),
                  CustomTextFormField(
                    labelText: 'Email',
                    controller: TextEditingController(),
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 18.h),
                  CustomTextFormField(
                    labelText: 'Password',
                    controller: TextEditingController(),
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  SizedBox(height: 36.h),
                  Center(
                      child: ColorChangingButton(
                    buttonText: "Sign Up",
                    onPressed: () {
                      context.pushNamed(Routes.navBar);
                    },
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
