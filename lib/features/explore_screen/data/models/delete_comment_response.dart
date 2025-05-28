class DeleteCommentResponse {
  final String message;

  DeleteCommentResponse({required this.message});

  factory DeleteCommentResponse.fromJson(Map<String, dynamic> json) {
    return DeleteCommentResponse(
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
