class PutSavedDesign {
  final String status;
  final String message;
  final SavedDesign savedDesign;

  PutSavedDesign({
    required this.status,
    required this.message,
    required this.savedDesign,
  });

  factory PutSavedDesign.fromJson(Map<String, dynamic> json) {
    return PutSavedDesign(
      status: json['status'],
      message: json['message'],
      savedDesign: SavedDesign.fromJson(json['savedDesign']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'savedDesign': savedDesign.toJson(),
    };
  }
}

class SavedDesign {
  final String id;
  final String generatedImageUrl;
  final String savedAt;
  final String applicationUserId;
  final dynamic applicationUser; // You can replace this later with a proper model
  final List<dynamic> comments; // You can replace this later with a Comment model
  final List<dynamic> likes; // You can replace this later with a Like model

  SavedDesign({
    required this.id,
    required this.generatedImageUrl,
    required this.savedAt,
    required this.applicationUserId,
    this.applicationUser,
    required this.comments,
    required this.likes,
  });

  factory SavedDesign.fromJson(Map<String, dynamic> json) {
    return SavedDesign(
      id: json['id'],
      generatedImageUrl: json['generatedImageUrl'],
      savedAt: json['savedAt'],
      applicationUserId: json['applicationUserId'],
      applicationUser: json['applicationUser'], // currently null
      comments: json['comments'] ?? [],
      likes: json['likes'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'generatedImageUrl': generatedImageUrl,
      'savedAt': savedAt,
      'applicationUserId': applicationUserId,
      'applicationUser': applicationUser,
      'comments': comments,
      'likes': likes,
    };
  }
}
