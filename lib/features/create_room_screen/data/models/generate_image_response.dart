class GeneratedImagesResponse {
  final String originalRoomImage;
  final String status;
  final List<String> generatedImageUrls;
  final List<HistoryResult> historyResults;

  GeneratedImagesResponse({
    required this.originalRoomImage,
    required this.status,
    required this.generatedImageUrls,
    required this.historyResults,
  });

  factory GeneratedImagesResponse.fromJson(Map<String, dynamic> json) {
    return GeneratedImagesResponse(
      originalRoomImage: json['originalRoomImage'],
      status: json['status'],
      generatedImageUrls: List<String>.from(json['generatedImageUrls']),
      historyResults: (json['historyResults'] as List)
          .map((e) => HistoryResult.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'originalRoomImage': originalRoomImage,
      'status': status,
      'generatedImageUrls': generatedImageUrls,
      'historyResults': historyResults.map((e) => e.toJson()).toList(),
    };
  }

}
class HistoryResult {
  final String id;
  final String generatedImageUrl;

  HistoryResult({
    required this.id,
    required this.generatedImageUrl,
  });

  factory HistoryResult.fromJson(Map<String, dynamic> json) {
    return HistoryResult(
      id: json['id'],
      generatedImageUrl: json['generatedImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'generatedImageUrl': generatedImageUrl,
    };
  }
}

