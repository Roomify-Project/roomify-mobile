import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/helpers/extensions.dart';
import 'package:rommify_app/core/routing/routes.dart';
import 'package:rommify_app/core/theming/colors.dart';
import 'package:rommify_app/core/widgets/animated_bottom_right.dart';
import 'package:rommify_app/core/widgets/animated_text_widget.dart';
import 'package:rommify_app/core/widgets/app_text_button.dart';
import 'package:rommify_app/core/widgets/app_text_form_field.dart';
import 'package:rommify_app/core/widgets/flutter_show_toast.dart';
import 'package:rommify_app/core/widgets/google_icon.dart';
import 'package:rommify_app/core/widgets/or_driver.dart';
import 'package:rommify_app/features/forget_password/logic/forget_cubit.dart';
import 'package:rommify_app/features/log_in/data/repos/login_repo.dart';
import 'package:rommify_app/features/log_in/logic/cubit/login_cubit.dart';
import 'package:rommify_app/features/log_in/logic/cubit/login_states.dart';
import 'package:rommify_app/features/log_in/ui/dont_have_account.dart';
import 'package:rommify_app/features/forget_password/ui/forget_password.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/helpers/app_regex.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.colorPrimary,
      body: Stack(
        children: [
          const StaticGradientBeam(), // الخلفية المتحركة
          SafeArea(
            child: SingleChildScrollView(
              child: BlocProvider(
                create: (BuildContext context) =>
                    LoginCubit(getIt.get<LoginRepo>()),
                child: BlocConsumer<LoginCubit, LoginStates>(
                  listener: (context, state) {
                    if (state is LoginLoadingState) {
                      EasyLoading.show();
                    }
                    if (state is LoginLoadingErrorState) {
                      flutterShowToast(
                          message: state.message, toastCase: ToastCase.error);
                      EasyLoading.dismiss();
                    }
                    if (state is LoginSuccessState) {
                      context.pushNamed(Routes.navBar);
                      EasyLoading.dismiss();
                    }
                  },
                  builder: (context, state) {
                    final loginCubit = LoginCubit.get(context);

                    return Form(
                      key: loginCubit.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30.h),
                          const Center(
                            child:  AnimatedText(text: 'Log In'),
                          ),
                          SizedBox(height: 20.h),
                          SingupRichText(
                            onLoginTap: () =>
                                context.pushNamed(Routes.signUpScreen),
                          ),
                          SizedBox(height: 67.h),
                          Center(child: GoogleIcon()),
                          SizedBox(height: 47.42.h),
                          OrDivider(),
                          SizedBox(height: 20.16.h),
                          CustomTextFormField(
                            labelText: 'Email',
                            controller: loginCubit.emailController,
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Email';
                              }
                              if (!AppRegex.isEmailValid(value)) {
                                return 'Use Valid E-mail';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 30.h),
                          CustomTextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Password';
                              }
                              return null;
                            },
                            labelText: 'Password',
                            controller: loginCubit.passwordController,
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 100, bottom: 60),
                            child: Center(
                              child: ColorChangingButton(
                                buttonText: "Log In",
                                onPressed: () {
                                  if (loginCubit.formKey.currentState!
                                      .validate()) {
                                    loginCubit.login();
                                  }
                                },
                              ),
                            ),
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  barrierColor:
                                      const Color(0xFF341D38).withOpacity(0.91),
                                  builder: (BuildContext context) {
                                    return BlocProvider(
                                      create: (context) =>
                                          getIt<ForgetPasswordCubit>(),
                                      child: const ForgetPasswordDialog(),
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
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
