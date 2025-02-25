// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../theming/styles.dart';
//
// void showErrorAnimation(BuildContext context, String message) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Error'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Lottie.asset('assets/animation/error_message.json'),  // Add your error animation JSON file here
//             const SizedBox(height: 10.0),
//             Text(message,),
//           ],
//         ),
//         backgroundColor: Colors.red[50],
//         titleTextStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//         contentTextStyle: const TextStyle(color: Colors.black),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('OK'),
//           ),
//         ],
//       );
//     },
//   );
// }
