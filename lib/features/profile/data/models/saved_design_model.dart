class SavedDesignsResponse {
  final String status;
  final List<SavedDesign> savedDesigns;

  SavedDesignsResponse({
    required this.status,
    required this.savedDesigns,
  });

  factory SavedDesignsResponse.fromJson(Map<String, dynamic> json) {
    return SavedDesignsResponse(
      status: json['status'],
      savedDesigns: List<SavedDesign>.from(
        json['savedDesigns'].map((x) => SavedDesign.fromJson(x)),
      ),
    );
  }
}

class SavedDesign {
  final String id;
  final String generatedImageUrl;
  final DateTime savedAt;
  final String applicationUserId;
  final dynamic applicationUser;

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
}
