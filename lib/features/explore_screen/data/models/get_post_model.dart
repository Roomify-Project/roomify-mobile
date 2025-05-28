class GetPostResponse {
  final String id;
  final String imagePath;
  final String description;
  final DateTime createdAt;
  final String applicationUserId;
  final String ownerUserName;
  final String? ownerProfilePicture;

  GetPostResponse({
    required this.id,
    required this.imagePath,
    required this.description,
    required this.createdAt,
    required this.applicationUserId,
    required this.ownerUserName,
    this.ownerProfilePicture,
  });

  factory GetPostResponse.fromJson(Map<String, dynamic> json) {
    return GetPostResponse(
      id: json['id'],
      imagePath: json['imagePath'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      applicationUserId: json['applicationUserId'],
      ownerUserName: json['ownerUserName'],
      ownerProfilePicture: json['ownerProfilePicture'],
    );
  }
}
