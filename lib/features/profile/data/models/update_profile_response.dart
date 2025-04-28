class UpdateProfileResponse {
  final String fullName;
  final String bio;
  final String profilePicture;
  final DateTime createdDate;
  final bool emailConfirmed;
  final int accessFailedCount;
  final String id;
  final String userName;
  final String normalizedUserName;
  final String email;
  final String normalizedEmail;
  final String passwordHash;
  final String securityStamp;
  final String concurrencyStamp;
  final bool phoneNumberConfirmed;
  final bool twoFactorEnabled;
  final bool lockoutEnabled;

  // ممكن تضيف المتغيرات دي كـ nullable لأنهم بيجوا null في البيانات
  final int? followers;
  final int? following;
  final String? provider;
  final String? providerId;
  final String? phoneNumber;
  final DateTime? lockoutEnd;

  UpdateProfileResponse({
    required this.fullName,
    required this.bio,
    required this.profilePicture,
    required this.createdDate,
    required this.emailConfirmed,
    required this.accessFailedCount,
    required this.id,
    required this.userName,
    required this.normalizedUserName,
    required this.email,
    required this.normalizedEmail,
    required this.passwordHash,
    required this.securityStamp,
    required this.concurrencyStamp,
    required this.phoneNumberConfirmed,
    required this.twoFactorEnabled,
    required this.lockoutEnabled,
    this.followers,
    this.following,
    this.provider,
    this.providerId,
    this.phoneNumber,
    this.lockoutEnd,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponse(
      fullName: json['fullName'] ?? '',
      bio: json['bio'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      createdDate: DateTime.parse(json['createdDate']),
      emailConfirmed: json['emailConfirmed'] ?? false,
      accessFailedCount: json['accessFailedCount'] ?? 0,
      id: json['id'] ?? '',
      userName: json['userName'] ?? '',
      normalizedUserName: json['normalizedUserName'] ?? '',
      email: json['email'] ?? '',
      normalizedEmail: json['normalizedEmail'] ?? '',
      passwordHash: json['passwordHash'] ?? '',
      securityStamp: json['securityStamp'] ?? '',
      concurrencyStamp: json['concurrencyStamp'] ?? '',
      phoneNumberConfirmed: json['phoneNumberConfirmed'] ?? false,
      twoFactorEnabled: json['twoFactorEnabled'] ?? false,
      lockoutEnabled: json['lockoutEnabled'] ?? false,
      followers: json['followers'],
      following: json['following'],
      provider: json['provider'],
      providerId: json['providerId'],
      phoneNumber: json['phoneNumber'],
      lockoutEnd: json['lockoutEnd'] != null ? DateTime.parse(json['lockoutEnd']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'bio': bio,
      'profilePicture': profilePicture,
      'createdDate': createdDate.toIso8601String(),
      'emailConfirmed': emailConfirmed,
      'accessFailedCount': accessFailedCount,
      'id': id,
      'userName': userName,
      'normalizedUserName': normalizedUserName,
      'email': email,
      'normalizedEmail': normalizedEmail,
      'passwordHash': passwordHash,
      'securityStamp': securityStamp,
      'concurrencyStamp': concurrencyStamp,
      'phoneNumberConfirmed': phoneNumberConfirmed,
      'twoFactorEnabled': twoFactorEnabled,
      'lockoutEnabled': lockoutEnabled,
      'followers': followers,
      'following': following,
      'provider': provider,
      'providerId': providerId,
      'phoneNumber': phoneNumber,
      'lockoutEnd': lockoutEnd?.toIso8601String(),
    };
  }
}
