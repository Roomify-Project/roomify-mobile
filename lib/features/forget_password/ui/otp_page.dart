// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
// import 'package:rommify_app/features/forget_password/ui/new_password.dart';
// import '../logic/forget_cubit.dart';
// import '../logic/forget_states.dart';

// class OtpPage extends StatelessWidget {
//   const OtpPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: context.read<ForgetPasswordCubit>(),
//       child: Dialog(
//         backgroundColor: Colors.transparent,
//         insetPadding: const EdgeInsets.only(
//           top: 100,
//           left: 18,
//           right: 18,
//         ),
//         child: Stack(
//           clipBehavior: Clip.none,
//           alignment: Alignment.topCenter,
//           children: [
//             _buildMainContainer(context),
//             _buildCloseButton(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMainContainer(BuildContext context) {
//     String otpCode = ""; // متغير لتخزين الكود

//     return BlocConsumer<ForgetPasswordCubit, ForgetPasswordStates>(
//       listener: (context, state) {
//         if (state is OtpVerificationSuccessState) {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (_) => BlocProvider.value(
//                 value: context.read<ForgetPasswordCubit>(),
//                 child: const NewPassword(),
//               ),
//             ),
//           );
//         } else if (state is OtpVerificationErrorState) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.message)),
//           );
//         }
//       },
//       builder: (context, state) {
//         return Container(
//           width: 368,
//           height: 313,
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//           decoration: BoxDecoration(
//             color: const Color(0xff210426),
//             borderRadius: BorderRadius.circular(50),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),
//               const Text(
//                 'Verify OTP',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const Text(
//                 'Enter the verification code sent to your email',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//               const SizedBox(height: 15),
//               OtpTextField(
//                 numberOfFields: 6,
//                 borderColor: const Color(0xFF320C39),
//                 showFieldAsBox: true,
//                 textStyle: const TextStyle(color: Colors.white),
//                 filled: true,
//                 fillColor: const Color(0xFF320C39),
//                 borderRadius: const BorderRadius.all(Radius.circular(15)),
//                 onCodeChanged: (String code) {
//                   otpCode = code; // تحديث قيمة الكود
//                 },
//                 onSubmit: (String verificationCode) {
//                   otpCode = verificationCode;
//                 },
//               ),
//               const SizedBox(height: 20),
//               // إضافة زر Verify
//               Center(
//                 child: SizedBox(
//                   width: 147,
//                   height: 47,
//                   child: ElevatedButton(
//                     onPressed: state is OtpVerificationLoadingState
//                         ? null
//                         : () {
//                             if (otpCode.length == 6) {
//                               context
//                                   .read<ForgetPasswordCubit>()
//                                   .verifyOtp(otpCode);
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text(
//                                       'Please enter the complete verification code'),
//                                 ),
//                               );
//                             }
//                           },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF320C39),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(17),
//                       ),
//                     ),
//                     child: state is OtpVerificationLoadingState
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text(
//                             'Verify',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildCloseButton(BuildContext context) {
//     return Positioned(
//       top: -69,
//       child: InkWell(
//         onTap: () => Navigator.of(context).pop(),
//         child: const CircleAvatar(
//           radius: 30,
//           backgroundColor: Colors.white,
//           child: Text(
//             '×',
//             style: TextStyle(
//               color: Color(0xFF311b35),
//               fontSize: 50,
//               fontWeight: FontWeight.bold,
//               height: 1,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:rommify_app/features/forget_password/ui/new_password.dart';
import '../logic/forget_cubit.dart';
import '../logic/forget_states.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
    );
  }

  Widget _buildMainContainer(BuildContext context) {
    String otpCode = "";

    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordStates>(
      listener: (context, state) {
        if (state is OtpVerificationSuccessState) {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Color(0xFF341D38).withOpacity(0.91),
            builder: (_) => BlocProvider.value(
              value: BlocProvider.of<ForgetPasswordCubit>(context),
              child: const NewPassword(),
            ),
          );
        } else if (state is OtpVerificationErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final cubit = BlocProvider.of<ForgetPasswordCubit>(context);
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
                'Verify OTP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Text(
                'Enter the verification code sent to your email',
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
                textStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF320C39),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                onCodeChanged: (String code) {
                  otpCode = code;
                },
                onSubmit: (String verificationCode) {
                  otpCode = verificationCode;
                  if (verificationCode.length == 6) {
                    cubit.verifyOtp(verificationCode);
                  }
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 147,
                  height: 47,
                  child: ElevatedButton(
                    onPressed: state is OtpVerificationLoadingState
                        ? null
                        : () {
                            if (otpCode.length == 6) {
                              cubit.verifyOtp(otpCode);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Please enter the complete verification code'),
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF320C39),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: state is OtpVerificationLoadingState
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Verify',
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
