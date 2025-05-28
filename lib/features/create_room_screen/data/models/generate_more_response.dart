class GenerateMoreImageResponse {
  final String status;
  final List<String> generatedImageUrls;
  final List<HistoryResult> historyResults;

  GenerateMoreImageResponse({
    required this.status,
    required this.generatedImageUrls,
    required this.historyResults,
  });

  factory GenerateMoreImageResponse.fromJson(Map<String, dynamic> json) {
    return GenerateMoreImageResponse(
      status: json['status'],
      generatedImageUrls: List<String>.from(json['generatedImageUrls']),
      historyResults: List<HistoryResult>.from(
        json['historyResults'].map((e) => HistoryResult.fromJson(e)),
      ),
    );
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
}
