class SavedDesignResponse {
  final String status;
  final String message;
  final SavedDesign savedDesign;

  SavedDesignResponse({
    required this.status,
    required this.message,
    required this.savedDesign,
  });

  factory SavedDesignResponse.fromJson(Map<String, dynamic> json) {
    return SavedDesignResponse(
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
  final DateTime savedAt;
  final String applicationUserId;
  final dynamic applicationUser; // you can define a class if needed

  SavedDesign({
    required this.id,
    required this.generatedImageUrl,
    required this.savedAt,
    required this.applicationUserId,
    this.applicationUser,
  });

  factory SavedDesign.fromJson(Map<String, dynamic> json) {
    return SavedDesign(
      id: json['id'],
      generatedImageUrl: json['generatedImageUrl'],
      savedAt: DateTime.parse(json['savedAt']),
      applicationUserId: json['applicationUserId'],
      applicationUser: json['applicationUser'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'generatedImageUrl': generatedImageUrl,
      'savedAt': savedAt.toIso8601String(),
      'applicationUserId': applicationUserId,
      'applicationUser': applicationUser,
    };
  }
}
