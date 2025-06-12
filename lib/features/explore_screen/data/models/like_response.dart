class LikeResponse {
  final String id;
  final String userId;
  final String? userName;
  final String? userProfilePicture;
  final DateTime createdAt;
  final String? portfolioPostId;
  final String? savedDesignId;

  LikeResponse({
    required this.id,
    required this.userId,
    this.userName,
    this.userProfilePicture,
    required this.createdAt,
    this.portfolioPostId,
    this.savedDesignId,
  });

  factory LikeResponse.fromJson(Map<String, dynamic> json) {
    return LikeResponse(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userProfilePicture: json['userProfilePicture'],
      createdAt: DateTime.parse(json['createdAt']),
      portfolioPostId: json['portfolioPostId'],
      savedDesignId: json['savedDesignId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userProfilePicture': userProfilePicture,
      'createdAt': createdAt.toIso8601String(),
      'portfolioPostId': portfolioPostId,
      'savedDesignId': savedDesignId,
    };
  }
}
