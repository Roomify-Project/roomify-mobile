class UpdateCommentModel {
  final String id;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final String userId;
  final String userName;
  final String? userProfilePicture;
  final String? portfolioPostId;
  final String? savedDesignId;

  UpdateCommentModel({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.userId,
    required this.userName,
    this.userProfilePicture,
    this.portfolioPostId,
    this.savedDesignId,
  });

  factory UpdateCommentModel.fromJson(Map<String, dynamic> json) {
    return UpdateCommentModel(
      id: json['id'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isDeleted: json['isDeleted'],
      userId: json['userId'],
      userName: json['userName'],
      userProfilePicture: json['userProfilePicture'],
      portfolioPostId: json['portfolioPostId'],
      savedDesignId: json['savedDesignId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isDeleted': isDeleted,
      'userId': userId,
      'userName': userName,
      'userProfilePicture': userProfilePicture,
      'portfolioPostId': portfolioPostId,
      'savedDesignId': savedDesignId,
    };
  }
}
