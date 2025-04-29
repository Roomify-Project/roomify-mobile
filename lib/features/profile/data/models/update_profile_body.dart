import 'dart:io';

import 'package:dio/dio.dart';

class UpdateProfileBody {
  final String userName;
  final String fullName;
  final String bio;
  final String email;
  final File? profilePicture;

  UpdateProfileBody({
    required this.userName,
    required this.fullName,
    required this.bio,
    required this.email,
     this.profilePicture,
  });

  factory UpdateProfileBody.fromJson(Map<String, dynamic> json) {
    return UpdateProfileBody(
      userName: json['userName'] ?? '',
      fullName: json['fullName'] ?? '',
      bio: json['bio'] ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'fullName': fullName,
      'bio': bio,
      'email': email,
      'profilePicture': profilePicture,
    };
  }
}
