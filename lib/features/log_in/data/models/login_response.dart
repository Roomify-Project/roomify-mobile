class LoginResponse {
  final String token;
  final String userName;
  final String roles;
  final String userId;

  LoginResponse({
    required this.token,
    required this.userName,
    required this.roles,
    required this.userId
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      userName: json['userName'] ?? '',
      roles: json['roles'] ?? '',
      userId: json['userId'] ?? '',
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