// forget_response.dart

class ForgetPasswordResponse {
  final String message;

  ForgetPasswordResponse({
    required this.message,
  });

  factory ForgetPasswordResponse.fromJson(dynamic json) {
    if (json is String) {
      return ForgetPasswordResponse(message: json);
    } else if (json is Map<String, dynamic>) {
      final message = json['message'] ?? json['msg'] ?? json['response'] ?? '';
      return ForgetPasswordResponse(message: message);
    } else {
      return ForgetPasswordResponse(message: "Success");
    }
  }
}

class ResetPasswordResponse {
  final String message;

  ResetPasswordResponse({
    required this.message,
  });

  factory ResetPasswordResponse.fromJson(dynamic json) {
    if (json is String) {
      return ResetPasswordResponse(message: json);
    } else if (json is Map<String, dynamic>) {
      final message = json['message'] ?? json['msg'] ?? json['response'] ?? '';
      return ResetPasswordResponse(message: message);
    } else {
      return ResetPasswordResponse(message: "Password reset successfully");
    }
  }
}