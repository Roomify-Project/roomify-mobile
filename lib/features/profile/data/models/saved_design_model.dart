class SavedDesignsResponse {
  final String status;
  final List<SavedDesignData> savedDesigns;

  SavedDesignsResponse({
    required this.status,
    required this.savedDesigns,
  });

  factory SavedDesignsResponse.fromJson(Map<String, dynamic> json) {
    return SavedDesignsResponse(
      status: json['status'],
      savedDesigns: (json['savedDesigns'] as List)
          .map((item) => SavedDesignData.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'savedDesigns': savedDesigns.map((item) => item.toJson()).toList(),
    };
  }
}

class SavedDesignData {
  final String id;
  final String generatedImageUrl;
  final String savedAt;
  final String userId;
  final String userFullName;
  final String? userProfilePicture;

  SavedDesignData({
    required this.id,
    required this.generatedImageUrl,
    required this.savedAt,
    required this.userId,
    required this.userFullName,
    this.userProfilePicture,
  });

  factory SavedDesignData.fromJson(Map<String, dynamic> json) {
    return SavedDesignData(
      id: json['id'],
      generatedImageUrl: json['generatedImageUrl'],
      savedAt: json['savedAt'],
      userId: json['userId'],
      userFullName: json['userFullName'],
      userProfilePicture: json['userProfilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'generatedImageUrl': generatedImageUrl,
      'savedAt': savedAt,
      'userId': userId,
      'userFullName': userFullName,
      'userProfilePicture': userProfilePicture,
    };
  }
}
