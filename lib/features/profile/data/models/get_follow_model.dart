class GetFollowModel {
  final List<GetFollowModelData> users;

  GetFollowModel({required this.users});

  factory GetFollowModel.fromJson(List<dynamic> json) {
    List<GetFollowModelData> users =
    json.map((item) => GetFollowModelData.fromJson(item)).toList();
    return GetFollowModel(users: users);
  }

  List<Map<String, dynamic>> toJson() {
    return users.map((user) => user.toJson()).toList();
  }
}

class GetFollowModelData {
  final String id;
  final String fullName;
  final String bio;
  final String profilePicture;
  final String userName;
  final String createdDate;

  GetFollowModelData({
    required this.id,
    required this.fullName,
    required this.bio,
    required this.profilePicture,
    required this.userName,
    required this.createdDate,
  });

  factory GetFollowModelData.fromJson(Map<String, dynamic> json) {
    return GetFollowModelData(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      bio: json['bio'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      userName: json['userName'] ?? '',
      createdDate: json['createdDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'bio': bio,
      'profilePicture': profilePicture,
      'userName': userName,
      'createdDate': createdDate,
    };
  }
}
