class SendMessageResponse {
  final String message;
  final String? attachmentUrl;

  SendMessageResponse({
    required this.message,
    this.attachmentUrl,
  });

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) {
    return SendMessageResponse(
      message: json['message'],
      attachmentUrl: json['attachmentUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'attachmentUrl': attachmentUrl,
    };
  }
}
