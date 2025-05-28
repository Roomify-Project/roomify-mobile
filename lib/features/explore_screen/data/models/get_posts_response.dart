class GetPostsResponse {
  final List<GetPostsResponseData> posts;

  GetPostsResponse({required this.posts});

  factory GetPostsResponse.fromJson(List<dynamic> json) {
    List<GetPostsResponseData> posts = json.map((item) => GetPostsResponseData.fromJson(item)).toList();
    return GetPostsResponse(posts: posts);
  }

  List<Map<String, dynamic>> toJson() {
    return posts.map((post) => post.toJson()).toList();
  }
}

class GetPostsResponseData {
  final String id;
  final String imagePath;
  final String description;
  final String createdAt;
  final String applicationUserId;
  final String? ownerUserName;
  final String? ownerProfilePicture;

  GetPostsResponseData( {
    required this.id,
    required this.imagePath,
    required this.description,
    required this.createdAt,
    required this.applicationUserId,
    this.ownerUserName, this.ownerProfilePicture,
  });

  factory GetPostsResponseData.fromJson(Map<String, dynamic> json) {
    return GetPostsResponseData(
      id: json['id'] ?? '',
      imagePath: json['imagePath'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'] ?? '',
      applicationUserId: json['applicationUserId'] ?? '',
      ownerUserName: json['ownerUserName'],
      ownerProfilePicture: json['ownerProfilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'description': description,
      'createdAt': createdAt,
      'applicationUserId': applicationUserId,
    };
  }
}