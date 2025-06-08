class SearchUserModel {
  final List<SearchUserModelData> users;

  SearchUserModel({required this.users});

  factory SearchUserModel.fromJson(List<dynamic> json) {
    List<SearchUserModelData> users =
    json.map((item) => SearchUserModelData.fromJson(item)).toList();
    return SearchUserModel(users: users);
  }

  List<Map<String, dynamic>> toJson() {
    return users.map((user) => user.toJson()).toList();
  }
}

class SearchUserModelData {
  final String id;
  final String userName;
  final String fullName;
  final String? profilePicture;
  final String email;

  SearchUserModelData({
    required this.id,
    required this.userName,
    required this.fullName,
    this.profilePicture,
    required this.email,
  });

  factory SearchUserModelData.fromJson(Map<String, dynamic> json) {
    return SearchUserModelData(
      id: json['id'] ?? '',
      userName: json['userName'] ?? '',
      fullName: json['fullName'] ?? '',
      profilePicture: json['profilePicture'],  // ممكن null
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'fullName': fullName,
      'profilePicture': profilePicture,
      'email': email,
    };
  }
}
