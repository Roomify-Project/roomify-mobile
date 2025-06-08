class GetAllChatResponse {
  final List<GetAllChatResponseData> chats;

  GetAllChatResponse({required this.chats});

  factory GetAllChatResponse.fromJson(List<dynamic> json) {
    List<GetAllChatResponseData> chats = json
        .map((item) => GetAllChatResponseData.fromJson(item))
        .toList();
    return GetAllChatResponse(chats: chats);
  }

  List<Map<String, dynamic>> toJson() {
    return chats.map((chat) => chat.toJson()).toList();
  }
}

class GetAllChatResponseData {
  final String chatWithUserId;
  final String chatWithName;
  final String? chatWithImageUrl;
  final String lastMessageContent;
  final String lastMessageTime;


  GetAllChatResponseData({
    required this.chatWithUserId,
    required this.chatWithName,
    required this.chatWithImageUrl,
    required this.lastMessageContent,
    required this.lastMessageTime,
  });

  factory GetAllChatResponseData.fromJson(Map<String, dynamic> json) {
    return GetAllChatResponseData(
      chatWithUserId: json['chatWithUserId'] as String,
      chatWithName: json['chatWithName'] as String,
      chatWithImageUrl: json['chatWithImageUrl'],
      lastMessageContent: json['lastMessageContent'] as String,
      lastMessageTime: json['lastMessageTime'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatWithUserId': chatWithUserId,
      'chatWithName': chatWithName,
      'chatWithImageUrl': chatWithImageUrl,
      'lastMessageContent': lastMessageContent,
      'lastMessageTime': lastMessageTime,
    };
  }

  /// ✅ copyWith method
  GetAllChatResponseData copyWith({
    String? chatWithUserId,
    String? chatWithName,
    String? chatWithImageUrl,
    String? lastMessageContent,
    String? lastMessageTime,
  }) {
    return GetAllChatResponseData(
      chatWithUserId: chatWithUserId ?? this.chatWithUserId,
      chatWithName: chatWithName ?? this.chatWithName,
      chatWithImageUrl: chatWithImageUrl ?? this.chatWithImageUrl,
      lastMessageContent: lastMessageContent ?? this.lastMessageContent,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
    );
  }
}
