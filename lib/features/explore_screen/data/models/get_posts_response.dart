class GetPostsResponse {
  final List<PortfolioPost> posts;
  final List<SavedDesign> savedDesigns;

  GetPostsResponse({
    required this.posts,
    required this.savedDesigns,
  });

  factory GetPostsResponse.fromJson(Map<String, dynamic> json) {
    return GetPostsResponse(
      posts: (json['portfolioPosts'] as List)
          .map((e) => PortfolioPost.fromJson(e))
          .toList(),
      savedDesigns: (json['savedDesigns'] as List)
          .map((e) => SavedDesign.fromJson(e))
          .toList(),
    );
  }
}

class PortfolioPost {
  final String id;
  final String imagePath;
  final String description;
  final DateTime createdAt;
  final String userId;
  final String userName;
  final String? userProfilePicture;
  final List<dynamic> comments;
  final int likesCount;
  final bool isLiked;

  PortfolioPost({
    required this.id,
    required this.imagePath,
    required this.description,
    required this.createdAt,
    required this.userId,
    required this.userName,
    this.userProfilePicture,
    required this.comments,
    required this.likesCount,
    required this.isLiked,
  });

  factory PortfolioPost.fromJson(Map<String, dynamic> json) {
    return PortfolioPost(
      id: json['id'],
      imagePath: json['imagePath'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      userId: json['userId'],
      userName: json['userName'],
      userProfilePicture: json['userProfilePicture'],
      comments: json['comments'] ?? [],
      likesCount: json['likesCount'],
      isLiked: json['isLiked'],
    );
  }

  PortfolioPost copyWith({
    String? id,
    String? imagePath,
    String? description,
    DateTime? createdAt,
    String? userId,
    String? userName,
    String? userProfilePicture,
    List<dynamic>? comments,
    int? likesCount,
    bool? isLiked,
  }) {
    return PortfolioPost(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfilePicture: userProfilePicture ?? this.userProfilePicture,
      comments: comments ?? this.comments,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

class SavedDesign {
  final String id;
  final String generatedImageUrl;
  final DateTime savedAt;
  final String userId;
  final String userName;
  final String? userProfilePicture;
  final List<dynamic> comments;
  final int likesCount;
  final bool isLiked;

  SavedDesign({
    required this.id,
    required this.generatedImageUrl,
    required this.savedAt,
    required this.userId,
    required this.userName,
    this.userProfilePicture,
    required this.comments,
    required this.likesCount,
    required this.isLiked,
  });

  factory SavedDesign.fromJson(Map<String, dynamic> json) {
    return SavedDesign(
      id: json['id'],
      generatedImageUrl: json['generatedImageUrl'],
      savedAt: DateTime.parse(json['savedAt']),
      userId: json['userId'],
      userName: json['userName'],
      userProfilePicture: json['userProfilePicture'],
      comments: json['comments'] ?? [],
      likesCount: json['likesCount'],
      isLiked: json['isLiked'],
    );
  }

  SavedDesign copyWith({
    String? id,
    String? generatedImageUrl,
    DateTime? savedAt,
    String? userId,
    String? userName,
    String? userProfilePicture,
    List<dynamic>? comments,
    int? likesCount,
    bool? isLiked,
  }) {
    return SavedDesign(
      id: id ?? this.id,
      generatedImageUrl: generatedImageUrl ?? this.generatedImageUrl,
      savedAt: savedAt ?? this.savedAt,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfilePicture: userProfilePicture ?? this.userProfilePicture,
      comments: comments ?? this.comments,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
