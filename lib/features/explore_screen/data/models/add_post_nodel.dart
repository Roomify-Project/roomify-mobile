class AddPostResponse {
  final String message;
  final String imageUrl;
  final String id;
  final String applicationUserId;
  final String description;

  AddPostResponse({
    required this.message,
    required this.imageUrl,
    required this.id,
    required this.applicationUserId,
    required this.description,
  });

  // Factory constructor to create Post from JSON
  factory AddPostResponse.fromJson(Map<String, dynamic> json) {
    return AddPostResponse(
      message: json['message'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      id: json['id'] ?? '',
      applicationUserId: json['applicationUserId'] ?? '',
      description: json['description'] ?? '',
    );
  }

  // Method to convert Post to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'imageUrl': imageUrl,
      'id': id,
      'applicationUserId': applicationUserId,
      'description': description,
    };
  }
}