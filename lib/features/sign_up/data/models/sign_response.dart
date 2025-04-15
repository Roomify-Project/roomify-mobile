class SignUpResponse {
  final String id;
  final String fullName;
  final String email;
  final String userName;

  SignUpResponse({
    required this.id,
    required this.fullName,
    required this.email,
    required this.userName,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      userName: json['userName'] ?? '',
    );
  }
}

class OtpResponse {
  final String message;

  OtpResponse({
    required this.message,
  });

  factory OtpResponse.fromJson(dynamic json) {
    // Added better handling for different response formats
    if (json is String) {
      return OtpResponse(message: json);
    } else if (json is Map<String, dynamic>) {
      // Check for various possible field names
      final message = json['message'] ?? json['msg'] ?? json['response'] ?? '';
      return OtpResponse(message: message);
    } else {
      print("Unexpected OTP response format: $json");
      return OtpResponse(message: "Success"); // Assume success if format is unexpected
    }
  }
}