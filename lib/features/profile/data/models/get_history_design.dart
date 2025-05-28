class ImageHistoryResponse {
  final String status;
  final List<ImageHistory> history;

  ImageHistoryResponse({
    required this.status,
    required this.history,
  });

  factory ImageHistoryResponse.fromJson(Map<String, dynamic> json) {
    return ImageHistoryResponse(
      status: json['status'],
      history: List<ImageHistory>.from(
        json['history'].map((x) => ImageHistory.fromJson(x)),
      ),
    );
  }
}

class ImageHistory {
  final String id;
  final String generatedImageUrl;
  final DateTime createdAt;
  final String applicationUserId;
  final dynamic applicationUser;
  final String promptId;
  final String? prompt;
  final bool isExpired;

  ImageHistory({
    required this.id,
    required this.generatedImageUrl,
    required this.createdAt,
    required this.applicationUserId,
    this.applicationUser,
    required this.promptId,
    this.prompt,
    required this.isExpired,
  });

  factory ImageHistory.fromJson(Map<String, dynamic> json) {
    return ImageHistory(
      id: json['id'],
      generatedImageUrl: json['generatedImageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      applicationUserId: json['applicationUserId'],
      applicationUser: json['applicationUser'],
      promptId: json['promptId'],
      prompt: json['prompt'],
      isExpired: json['isExpired'],
    );
  }
}
