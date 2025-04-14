class GetPostResponse {
  final String id;
  final String imagePath;
  final String description;
  final String createdAt;
  final String applicationUserId;

  GetPostResponse({required this.id,
    required this.imagePath,
    required this.description,
    required this.createdAt,
    required this.applicationUserId});

  factory GetPostResponse.fromJson(Map<String, dynamic> json) {
    return GetPostResponse(
        id: json['id'] ?? '',
        imagePath:  json['imagePath'] ?? '',
        description: json['description'] ?? '',
        createdAt: json['createdAt'] ?? '',
        applicationUserId: json['applicationUserId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imagePath'] = this.imagePath;
    data['description'] = this.description;
    data['createdAt'] = this.createdAt;
    data['applicationUserId'] = this.applicationUserId;
    return data;
  }
}