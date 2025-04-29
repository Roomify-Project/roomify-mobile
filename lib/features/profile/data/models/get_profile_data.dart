class GetProfileDataModel {
  final String id;
  final String userName;
  final String fullName;
  final String bio;
  final String email;
  final String? profilePicture;
  final String? phoneNumber;
  final String role;
  final bool emailConfirmed;

  GetProfileDataModel({
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

  factory GetProfileDataModel.fromJson(Map<String, dynamic> json) {
    return GetProfileDataModel(
      id: json['id'],
      userName: json['userName'],
      fullName: json['fullName'],
      bio: json['bio'],
      email: json['email'],
      profilePicture: json['profilePicture']??"",
      phoneNumber: json['phoneNumber']??"",
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
