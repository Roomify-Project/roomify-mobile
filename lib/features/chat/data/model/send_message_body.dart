class SendChatMessageBody {
  final String senderId;
  final String receiverId;
  final String message;


  SendChatMessageBody({
    required this.senderId,
    required this.receiverId,
    required this.message,
  });

  factory SendChatMessageBody.fromJson(Map<String, dynamic> json) {
    return SendChatMessageBody(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
    };
  }
}
