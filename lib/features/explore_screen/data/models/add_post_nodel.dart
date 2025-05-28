class AddPostResponse {
  final String message;
  final String imagePath;
  final String id;
  final User user;

  AddPostResponse({
    required this.message,
    required this.imagePath,
    required this.id,
    required this.user,
  });

  factory AddPostResponse.fromJson(Map<String, dynamic> json) {
    return AddPostResponse(
      message: json['message'],
      imagePath: json['imagePath'],
      id: json['id'],
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final String id;
  final String userName;
  final String? profilePicture;

  User({
    required this.id,
    required this.userName,
    this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userName: json['userName'],
      profilePicture: json['profilePicture'],
    );
  }
}
