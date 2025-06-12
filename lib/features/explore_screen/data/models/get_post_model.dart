class GetPostResponse {
  final String type;
  final PostData postData;

  GetPostResponse({
    required this.type,
    required this.postData,
  });

  factory GetPostResponse.fromJson(Map<String, dynamic> json) {
    return GetPostResponse(
      type: json['type'],
      postData: PostData.fromJson(json['data'], json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'data': postData.toJson(type),
    };
  }

  GetPostResponse copyWith({
    String? type,
    PostData? postData,
  }) {
    return GetPostResponse(
      type: type ?? this.type,
      postData: postData ?? this.postData,
    );
  }
}

class PostData {
  final String id;
  final String imagePath;
  final String? description;
  final DateTime createdAt;
  final String userId;
  final String userName;
  final String? userProfilePicture;
  final List<CommentModel> comments;
  final int likesCount;

  PostData({
    required this.id,
    required this.imagePath,
    this.description,
    required this.createdAt,
    required this.userId,
    required this.userName,
    this.userProfilePicture,
    required this.comments,
    required this.likesCount,
  });

  factory PostData.fromJson(Map<String, dynamic> json, String type) {
    return PostData(
      id: json['id'],
      imagePath: type == 'Design' ? json['generatedImageUrl'] : json['imagePath'],
      description: type == 'Design' ? null : json['description'],
      createdAt: DateTime.parse(type == 'Design' ? json['savedAt'] : json['createdAt']),
      userId: json['userId'],
      userName: json['userName'],
      userProfilePicture: json['userProfilePicture'],
      comments: (json['comments'] as List<dynamic>? ?? [])
          .map((e) => CommentModel.fromJson(e))
          .toList(),
      likesCount: json['likesCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson(String type) {
    return {
      'id': id,
      if (type == 'Design')
        'generatedImageUrl': imagePath
      else
        'imagePath': imagePath,
      if (type != 'Design') 'description': description,
      type == 'Design' ? 'savedAt' : 'createdAt': createdAt.toIso8601String(),
      'userId': userId,
      'userName': userName,
      'userProfilePicture': userProfilePicture,
      'comments': comments.map((c) => c.toJson()).toList(),
      'likesCount': likesCount,
    };
  }

  PostData copyWith({
    String? id,
    String? imagePath,
    String? description,
    DateTime? createdAt,
    String? userId,
    String? userName,
    String? userProfilePicture,
    List<CommentModel>? comments,
    int? likesCount,
  }) {
    return PostData(
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

class CommentModel {
  final String id;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isDeleted;
  final String userId;
  final String userName;
  final String? userProfilePicture;
  final String? portfolioPostId;
  final String? savedDesignId;

  CommentModel({
    required this.id,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    required this.isDeleted,
    required this.userId,
    required this.userName,
    this.userProfilePicture,
    this.portfolioPostId,
    this.savedDesignId,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      isDeleted: json['isDeleted'],
      userId: json['userId'],
      userName: json['userName'],
      userProfilePicture: json['userProfilePicture'],
      portfolioPostId: json['portfolioPostId'], // ممكن تكون null
      savedDesignId: json['savedDesignId'],     // ممكن تكون null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted,
      'userId': userId,
      'userName': userName,
      'userProfilePicture': userProfilePicture,
      'portfolioPostId': portfolioPostId,
      'savedDesignId': savedDesignId,
    };
  }

  CommentModel copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    String? userId,
    String? userName,
    String? userProfilePicture,
    String? portfolioPostId,
    String? savedDesignId,
  }) {
    return CommentModel(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfilePicture: userProfilePicture ?? this.userProfilePicture,
      portfolioPostId: portfolioPostId ?? this.portfolioPostId,
      savedDesignId: savedDesignId ?? this.savedDesignId,
    );
  }
}
