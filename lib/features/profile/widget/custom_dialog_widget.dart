// import 'package:flutter/material.dart';
// import 'package:rommify_app/features/profile/widget/custom_text_field.dart';

// class ChangePasswordDialog extends StatelessWidget {
//   const ChangePasswordDialog({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: const EdgeInsets.only(
//         top: 100,
//         left: 18,
//         right: 18,
//       ),
//       child: Stack(
//         clipBehavior: Clip.none,
//         alignment: Alignment.topCenter,
//         children: [
//           _buildMainContainer(),
//           _buildCloseButton(context),
//         ],
//       ),
//     );
//   }

//   Widget _buildMainContainer() {
//     return Container(
//       width: 368,
//       height: 313,
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//       decoration: BoxDecoration(
//         color: const Color(0xff210426),
//         borderRadius: BorderRadius.circular(50),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const SizedBox(height: 20),
//           CustomTextField(
//             hint: 'OLD PASSWORD',
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter your old password';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: 15),
//           CustomTextField(
//             hint: 'NEW PASSWORD',
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter your new password';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: 20),
//           _buildConfirmButton(),
//         ],
//       ),
//     );
//   }

//   Widget _buildConfirmButton() {
//     return SizedBox(
//       width: 147,
//       height: 47,
//       child: ElevatedButton(
//         onPressed: () {},
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF320C39),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(17),
//           ),
//         ),
//         child: const Text(
//           'CONFIRM',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
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