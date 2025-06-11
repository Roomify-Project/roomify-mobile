class GetMessageResponse {
  final List<GetMessageResponseData> messages;

  GetMessageResponse({required this.messages});

  factory GetMessageResponse.fromJson(List<dynamic> json) {
    List<GetMessageResponseData> messages = json.map((item) => GetMessageResponseData.fromJson(item)).toList();
    return GetMessageResponse(messages: messages);
  }
  List<Map<String, dynamic>> toJson() {
    return messages.map((message) => message.toJson()).toList();
  }
}

class GetMessageResponseData {
  final String messageId;
  final String senderId;
  final String content;
  final String sentAt;
  final dynamic attachmentUrl;

  GetMessageResponseData({
    required this.messageId,
    required this.senderId,
    required this.content,
    required this.sentAt,
    required this.attachmentUrl,
  });

  factory GetMessageResponseData.fromJson(Map<String, dynamic> json) {
    return GetMessageResponseData(
      messageId: json['messageId'] as String,
      senderId: json['senderId'] as String,
      content: json['content'] as String,
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

  // إضافة copyWith
  GetMessageResponseData copyWith({
    String? messageId,
    String? senderId,
    String? content,
    String? sentAt,
    dynamic attachmentUrl,
  }) {
    return GetMessageResponseData(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      sentAt: sentAt ?? this.sentAt,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
    );
  }
}
