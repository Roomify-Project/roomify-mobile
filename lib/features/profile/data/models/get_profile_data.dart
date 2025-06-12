class GetProfileDataModel {
  final String id;
  final String userName;
  final String fullName;
  final String bio;
  final String email;
  final String? profilePicture; // ✅ null safety
  final String? phoneNumber;    // ✅ null safety
  final String role;
  final bool emailConfirmed;

  GetProfileDataModel({
    required this.id,
    required this.userName,
    required this.fullName,
    required this.bio,
    required this.email,
    this.profilePicture, // ✅
    this.phoneNumber,    // ✅
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
      profilePicture: json['profilePicture'], // might be null
      phoneNumber: json['phoneNumber'],       // might be null
      role: json['roles'],
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
      'roles': role,
      'emailConfirmed': emailConfirmed,
    };
  }
}
