import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import '../../logic/cubit/sign_cubit.dart';
import '../../logic/cubit/sign_states.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String otpCode = '';
  bool isLoading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    // Get the cubit directly from the context
    final signUpCubit = context.read<SignUpCubit>();

    return BlocListener<SignUpCubit, SignUpStates>(
      listener: (context, state) {
        if (state is OtpLoadingState) {
          setState(() {
            isLoading = true;
            errorMessage = null;
          });
        } else if (state is OtpSuccessState) {
          setState(() {
            isLoading = false;
            errorMessage = null;
          });
          Navigator.of(context).pop(true); // Return true to indicate success
        } else if (state is OtpLoadingErrorState) {
          setState(() {
            isLoading = false;
            errorMessage = state.message;
          });
        }
      },
      child: Dialog(
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
            _buildMainContainer(context, signUpCubit),
            _buildCloseButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContainer(BuildContext context, SignUpCubit cubit) {
    return Container(
      width: 368,
      // Increased height to accommodate error message
      height: errorMessage != null ? 360 : 313,
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
            'Confirm OTP',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Text(
            'Type your OTP code',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 15),
          OtpTextField(
            numberOfFields: 6,
            borderColor: const Color(0xFF320C39),
            showFieldAsBox: true,
            onCodeChanged: (String code) {
              otpCode = code;
              // Clear error message when user starts typing
              if (errorMessage != null) {
                setState(() {
                  errorMessage = null;
                });
              }
            },
            onSubmit: (String verificationCode) {
              otpCode = verificationCode;
              if (otpCode.length == 6) {
                cubit.verifyOtp(otpCode);
              }
            },
            textStyle: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF320C39),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: 10),
            Center(
              child: Text(
                errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 147,
              height: 47,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        if (otpCode.length == 6) {
                          cubit.verifyOtp(otpCode);
                        } else {
                          setState(() {
                            errorMessage = "Please enter the complete 6-digit verification code";
                          });
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF320C39),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: isLoading
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
  }

  Widget _buildCloseButton(BuildContext context) {
    return Positioned(
      top: -40, // Changed from -69 to make it more visible
      child: GestureDetector( // Changed from InkWell to GestureDetector for better touch response
        onTap: () => Navigator.of(context).pop(false), // Added false to indicate cancellation
        child: Container( // Wrapped CircleAvatar in Container to increase tap area
          padding: const EdgeInsets.all(5),
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
      ),
    );
  }
}