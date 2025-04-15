// forget_request_body.dart

class ForgetPasswordRequestBody {
  final String email;

  ForgetPasswordRequestBody({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

class ForgetPasswordOtpRequestBody {
  final String email;
  final String otpCode;

  ForgetPasswordOtpRequestBody({
    required this.email,
    required this.otpCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otpCode': otpCode,
    };
  }
}

class ResetPasswordRequestBody {
  final String email;
  final String newPassword;
  final String otpCode;

  ResetPasswordRequestBody({
    required this.email,
    required this.newPassword,
    required this.otpCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otpCode': otpCode,
      'newPassword': newPassword,
    };
  }
}