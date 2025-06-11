class SendMessageResponse {
  final String message;
  final MessageData messageData;

  SendMessageResponse({required this.message, required this.messageData});

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) {
    return SendMessageResponse(
      message: json['message'],
      messageData: MessageData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': messageData.toJson(),
    };
  }
}

class MessageData {
  final String messageId;
  final String senderId;
  final String content;
  final String sentAt;
  final String? attachmentUrl;

  MessageData({
    required this.messageId,
    required this.senderId,
    required this.content,
    required this.sentAt,
    this.attachmentUrl,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      messageId: json['messageId'],
      senderId: json['senderId'],
      content: json['content'],
      sentAt: json['sentAt'],
      attachmentUrl: json['attachmentUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'content': content,
      'sentAt': sentAt,
      'attachmentUrl': attachmentUrl,
    };
  }
}
