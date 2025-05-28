class GetCommentResponse {
  final List<CommentData> comments;

  GetCommentResponse({required this.comments});

  factory GetCommentResponse.fromJson(List<dynamic> json) {
    List<CommentData> comments = json.map((item) => CommentData.fromJson(item)).toList();
    return GetCommentResponse(comments: comments);
  }

  List<Map<String, dynamic>> toJson() {
    return comments.map((comment) => comment.toJson()).toList();
  }
}

class CommentData {
  final String id;
  final String content;
  final String createdAt;
  final String? updatedAt;
  final String userId;
  final String userName;
  final String? userProfilePicture;
  final String portfolioPostId;

  CommentData({
    required this.id,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    required this.userId,
    required this.userName,
    this.userProfilePicture,
    required this.portfolioPostId,
  });

  factory CommentData.fromJson(Map<String, dynamic> json) {
    return CommentData(
      id: json['id'],
      content: json['content'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      userId: json['userId'],
      userName: json['userName'],
      userProfilePicture: json['userProfilePicture'],
      portfolioPostId: json['portfolioPostId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'userId': userId,
      'userName': userName,
      'userProfilePicture': userProfilePicture,
      'portfolioPostId': portfolioPostId,
    };
  }

  CommentData copyWith({
    String? id,
    String? content,
    String? createdAt,
    String? updatedAt,
    String? userId,
    String? userName,
    String? userProfilePicture,
    String? portfolioPostId,
  }) {
    return CommentData(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfilePicture: userProfilePicture ?? this.userProfilePicture,
      portfolioPostId: portfolioPostId ?? this.portfolioPostId,
    );
  }
}
