import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rommify_app/core/di/dependency_injection.dart';
import 'package:rommify_app/features/forget_password/logic/forget_cubit.dart';
import 'package:rommify_app/features/forget_password/logic/forget_states.dart';
import 'package:rommify_app/features/forget_password/ui/otp_page.dart';
import 'package:rommify_app/features/profile/widget/custom_text_field.dart';

class ForgetPasswordDialog extends StatefulWidget {
  const ForgetPasswordDialog({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordDialog> createState() => _ForgetPasswordDialogState();
}

class _ForgetPasswordDialogState extends State<ForgetPasswordDialog> {
  late ForgetPasswordCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ForgetPasswordCubit>();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Builder(
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
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
      ),
    );
  }

  Widget _buildMainContainer(BuildContext context) {
    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordStates>(
      listener: (context, state) {
        if (state is ForgetPasswordSuccessState) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: _cubit,
                child: const OtpPage(),
              ),
            ),
          );
        } else if (state is ForgetPasswordLoadingErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
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
              const Text(
                'Reset password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Text(
                'Type your email to send OTP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 15),
              CustomTextField(
                hint: 'E-mail',
                controller: _cubit.emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {},
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 147,
                  height: 47,
                  child: ElevatedButton(
                    onPressed: state is ForgetPasswordLoadingState
                        ? null
                        : () {
                            final email = _cubit.emailController.text.trim();
                            if (email.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter your email'),
                                ),
                              );
                              return;
                            }
                            _cubit.sendOtp();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF320C39),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: state is ForgetPasswordLoadingState
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
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


