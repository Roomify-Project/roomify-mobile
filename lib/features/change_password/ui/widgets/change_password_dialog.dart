// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:rommify_app/features/change_password/logic/cubit/change_password_states.dart';
// import '../../../../core/theming/colors.dart';
// import '../../../../core/widgets/flutter_show_toast.dart';
// import '../../../profile/widget/custom_button.dart';
// import '../../../profile/widget/custom_text_field.dart';
// import '../../logic/cubit/change_password_cubit.dart';


// class ChangePasswordDialog extends StatelessWidget {
//   const ChangePasswordDialog({super.key, required Form child});

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
//       listener: (context, state) {
//         if (state is ChangePasswordLoading) {
//           EasyLoading.show();
//         } else if (state is ChangePasswordSuccess) {
//           EasyLoading.dismiss();
//           Navigator.pop(context);
//           flutterShowToast(message: state.message, toastCase: ToastCase.success);
//         } else if (state is ChangePasswordError) {
//           EasyLoading.dismiss();
//           flutterShowToast(message: state.message, toastCase: ToastCase.error);
//         }
//       },
//       builder: (context, state) {
//         final cubit = ChangePasswordCubit.get(context);
        
//         return ChangePasswordDialog(
//           child: Form(
//             key: cubit.formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   'CHANGE PASSWORD',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
                
//                 CustomTextField(
//                   controller: cubit.currentPasswordController,
//                   hint: 'CURRENT PASSWORD',
        
//                   validator: (value) {
//                     if (value?.isEmpty ?? true) {
//                       return 'Please enter current password';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 15),
                
//                 CustomTextField(
//                   controller: cubit.newPasswordController,
//                   hint: 'NEW PASSWORD',
               
//                   validator: (value) {
//                     if (value?.isEmpty ?? true) {
//                       return 'Please enter new password';
//                     }
//                     if (value!.length < 6) {
//                       return 'Password must be at least 6 characters';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 15),
                
//                 CustomTextField(
//                   controller: cubit.confirmPasswordController,
//                   hint: 'CONFIRM PASSWORD',
                 
//                   validator: (value) {
//                     if (value?.isEmpty ?? true) {
//                       return 'Please confirm your new password';
//                     }
//                     if (value != cubit.newPasswordController.text) {
//                       return 'Passwords do not match';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 30),
                
//                 CustomButton(
//                   text: 'SAVE',
//                   onPressed: () => cubit.changePassword(),
//                   color: ColorsManager.mainBurble,
//                   width: 147,
//                   height: 47,
//                 ),
                
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text(
//                     'CANCEL',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }