class GetUserPost {
  final List<PostInformation> posts;

  GetUserPost({required this.posts});

  factory GetUserPost.fromJson(List<dynamic> json) {
    List<PostInformation> posts = json.map((item) => PostInformation.fromJson(item)).toList();
    return GetUserPost(posts: posts);
  }

  List<Map<String, dynamic>> toJson() {
    return posts.map((post) => post.toJson()).toList();
  }
}

class PostInformation {
  final String id;
  final String imagePath;
  final String description;
  final String createdAt;
  final String userId;
  final String? userName;
  final String? userProfilePicture;
  final dynamic comments; // ممكن تغيره لاحقًا حسب نوع التعليقات
  final int likesCount;

  PostInformation({
    required this.id,
    required this.imagePath,
    required this.description,
    required this.createdAt,
    required this.userId,
    this.userName,
    this.userProfilePicture,
    this.comments,
    required this.likesCount,
  });

  factory PostInformation.fromJson(Map<String, dynamic> json) {
    return PostInformation(
      id: json['id'],
      imagePath: json['imagePath'],
      description: json['description'],
      createdAt: json['createdAt'],
      userId: json['userId'],
      userName: json['userName'],
      userProfilePicture: json['userProfilePicture'],
      comments: json['comments'],
      likesCount: json['likesCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'description': description,
      'createdAt': createdAt,
      'userId': userId,
      'userName': userName,
      'userProfilePicture': userProfilePicture,
      'comments': comments,
      'likesCount': likesCount,
    };
  }

  PostInformation copyWith({
    String? id,
    String? imagePath,
    String? description,
    String? createdAt,
    String? userId,
    String? userName,
    String? userProfilePicture,
    dynamic comments,
    int? likesCount,
  }) {
    return PostInformation(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfilePicture: userProfilePicture ?? this.userProfilePicture,
      comments: comments ?? this.comments,
      likesCount: likesCount ?? this.likesCount,
    );
  }
}
