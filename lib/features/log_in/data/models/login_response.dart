class LoginResponse {
  final String token;
  final String userName;
  final String roles;

  LoginResponse({
    required this.token,
    required this.userName,
    required this.roles,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      userName: json['userName'] ?? '',
      roles: json['roles'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userName': userName,
      'roles': roles,
    };
  }
}