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
      senderId: json['SenderId'],
      receiverId: json['ReceiverId'],
      message: json['Message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SenderId': senderId,
      'ReceiverId': receiverId,
      'Message': message,
    };
  }
}
