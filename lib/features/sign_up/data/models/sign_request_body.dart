class SignUpRequestBody {
  String fullName;
  String email;
  String password;
  String userName;
  String role;

  SignUpRequestBody({
    required this.fullName,
    required this.email,
    required this.password,
    required this.userName,
    required this.role
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'userName': userName,
      'bio': 'Developer',
      'profilePicture': '',
      'roles': role,

    };
  }
}

class OtpRequestBody {
  final String email;
  final String otpCode;

  OtpRequestBody({
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