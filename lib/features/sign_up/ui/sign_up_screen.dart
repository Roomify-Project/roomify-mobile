import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/helpers/extensions.dart';
import 'package:rommify_app/core/helpers/spacing.dart';
import 'package:rommify_app/features/sign_up/ui/widget/aready_have_account_text.dart';
import 'package:rommify_app/features/sign_up/ui/widget/otp_screen.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/helpers/app_regex.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theming/colors.dart';
import '../../../core/widgets/animated_bottom_right.dart';
import '../../../core/widgets/animated_text_widget.dart';
import '../../../core/widgets/app_text_button.dart';
import '../../../core/widgets/app_text_form_field.dart';
import '../../../core/widgets/flutter_show_toast.dart';
import '../../../core/widgets/google_icon.dart';
import '../../../core/widgets/or_driver.dart';
import '../data/repos/sign_repo.dart';
import '../logic/cubit/sign_cubit.dart';
import '../logic/cubit/sign_states.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.colorPrimary,
      body: Stack(
        children: [
          const StaticGradientBeam(),
          SafeArea(
            child: SingleChildScrollView(
              child: BlocProvider(
                create: (BuildContext context) =>
                    SignUpCubit(getIt.get<SignUpRepo>()),
                child: BlocConsumer<SignUpCubit, SignUpStates>(
                  listener: (context, state) {
                    if (state is SignUpLoadingState) {
                      EasyLoading.show();
                    }
                    if (state is SignUpLoadingErrorState) {
                      flutterShowToast(
                          message: state.message, toastCase: ToastCase.error);
                      EasyLoading.dismiss();
                    }
                    if (state is SignUpSuccessState) {
                      EasyLoading.dismiss();
                      final currentCubit =
                          BlocProvider.of<SignUpCubit>(context);
                      showDialog(
                        context: context,
                        barrierColor: const Color(0xFF341D38).withOpacity(0.91),
                        barrierDismissible: false,
                        builder: (dialogContext) {
                          return BlocProvider.value(
                            value: currentCubit,
                            child: OtpScreen(),
                          );
                        },
                      ).then((otpResult) {
                        if (otpResult == true) {
                          context.pushReplacementNamed(Routes.loginScreen);
                        }
                      });
                    }
                  },
                  builder: (context, state) {
                    final signUpCubit = SignUpCubit.get(context);
                    return Form(
                      key: signUpCubit.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          verticatSpace(30),
                          Center(child: const AnimatedText(text: 'Sign up')),
                          verticatSpace(15),
                          LoginRichText(
                            onLoginTap: () {
                              context.pushNamed(Routes.loginScreen);
                            },
                          ),
                          verticatSpace(30),
                          Center(child: GoogleIcon()),
                          verticatSpace(30),
                          OrDivider(),
                          verticatSpace(61),
                          CustomTextFormField(
                            labelText: 'Full Name',
                            controller: signUpCubit.fullNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                            obscureText: false,
                          ),
                          SizedBox(height: 20.h),
                          CustomTextFormField(
                            labelText: 'User Name',
                            controller: signUpCubit.userNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                            obscureText: false,
                          ),
                          SizedBox(height: 20.h),
                          CustomTextFormField(
                            labelText: 'E-mail',
                            controller: signUpCubit.emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!AppRegex.isEmailValid(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            obscureText: false,
                          ),
                          SizedBox(height: 20.h),
                          CustomTextFormField(
                            labelText: 'Password',
                            controller: signUpCubit.passwordController,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (!AppRegex.isPasswordValid(value)) {
                                return 'Use At Least 8 Characters One Uppercase Letter\nOneLowercase Letter And One Number In\nYour Password';
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 100, bottom: 60),
                            child: Center(
                              child: ColorChangingButton(
                                buttonText: "Sign Up",
                                onPressed: () {
                                  if (signUpCubit.formKey.currentState!
                                      .validate()) {
                                    signUpCubit.signUp();
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
