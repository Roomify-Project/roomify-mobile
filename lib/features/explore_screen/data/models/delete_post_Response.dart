class DeletePostResponse {
  final String message;

  DeletePostResponse({
    required this.message,
  });

  factory DeletePostResponse.fromJson(Map<String, dynamic> json) {
    return DeletePostResponse(
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}