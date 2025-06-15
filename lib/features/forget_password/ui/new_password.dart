import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/forget_cubit.dart';
import '../logic/forget_states.dart';
import '../../profile/widget/custom_text_field.dart';

class NewPassword extends StatelessWidget {
  const NewPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ForgetPasswordCubit>(),
      child: Dialog(
        backgroundColor: Colors.red,
        insetPadding: const EdgeInsets.only(
          top: 100,
          left: 18,
          right: 18,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            _buildMainContainer(context),
            _buildCloseButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContainer(BuildContext context) {
    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordStates>(
      listener: (context, state) {
        if (state is ResetPasswordSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('Password reset successfully'.tr())),
          );
          // Navigate to the login screen
          Navigator.of(context).pushNamedAndRemoveUntil('/loginScreen', (route) => false);
        } else if (state is ResetPasswordErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<ForgetPasswordCubit>();
        
        return Container(
          width: 368,
          height: 313,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            color: const Color(0xff210426),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
               Text(
                'New Password'.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
               Text(
                'Enter your new password'.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 15),
              CustomTextField(
                hint: 'New Password'.tr(),
                controller: cubit.passwordController,
                obscureText: true,
                validator: (value) {},
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 147,
                  height: 47,
                  child: ElevatedButton(
                    onPressed: state is ResetPasswordLoadingState
                        ? null
                        : () {
                            final password = cubit.passwordController.text;
                            if (password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(
                                  content: Text('Please enter a new password'.tr()),
                                ),
                              );
                              return;
                            }
                            cubit.resetPassword();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF320C39),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: state is ResetPasswordLoadingState
                        ? const CircularProgressIndicator(color: Colors.white)
                        :  Text(
                            'Confirm'.tr(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Positioned(
      top: -69,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(),
        child: const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Text(
            '×',
            style: TextStyle(
              color: Color(0xFF311b35),
              fontSize: 50,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}