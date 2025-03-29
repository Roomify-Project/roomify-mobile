import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/helpers/extensions.dart';
import 'package:rommify_app/core/helpers/spacing.dart';
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
                  verticatSpace(44),
                  Center(child: GoogleIcon()),
                  verticatSpace(47.42),
                  OrDivider(),
                  verticatSpace(61.16),
                  CustomTextFormField(
                    labelText: 'Full Name',
                    controller: TextEditingController(),
                    obscureText: false,
                    keyboardType: TextInputType.name,
                  ),
                  verticatSpace(18),
                  CustomTextFormField(
                    labelText: 'Username',
                    controller: TextEditingController(),
                    obscureText: false,
                    keyboardType: TextInputType.name,
                  ),
                  verticatSpace(18),
                  CustomTextFormField(
                    labelText: 'Email',
                    controller: TextEditingController(),
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  verticatSpace(18),
                  CustomTextFormField(
                    labelText: 'Password',
                    controller: TextEditingController(),
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  verticatSpace(36),
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
