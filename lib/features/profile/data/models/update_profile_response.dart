class UpdateProfileResponse {
  final String message;
  final User user;

  UpdateProfileResponse({
    required this.message,
    required this.user,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponse(
      message: json['message'],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user.toJson(),
    };
  }
}

class User {
  final String id;
  final String userName;
  final String fullName;
  final String bio;
  final String email;
  final String? profilePicture;
  final String? phoneNumber;
  final String role;
  final bool emailConfirmed;

  User({
    required this.id,
    required this.userName,
    required this.fullName,
    required this.bio,
    required this.email,
    this.profilePicture,
    this.phoneNumber,
    required this.role,
    required this.emailConfirmed,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userName: json['userName'],
      fullName: json['fullName'],
      bio: json['bio'],
      email: json['email'],
      profilePicture: json['profilePicture'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      emailConfirmed: json['emailConfirmed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'fullName': fullName,
      'bio': bio,
      'email': email,
      'profilePicture': profilePicture,
      'phoneNumber': phoneNumber,
      'role': role,
      'emailConfirmed': emailConfirmed,
    };
  }
}
