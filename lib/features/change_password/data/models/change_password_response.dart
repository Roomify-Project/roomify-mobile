// class ChangePasswordResponse {
//   final String message;
//   final bool success;

//   const ChangePasswordResponse({
//     required this.message,
//     required this.success,
//   });

//   factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
//     return ChangePasswordResponse(
//       message: json['message'] ?? 'Password changed successfully',
//       success: true,
//     );
//   }
// }