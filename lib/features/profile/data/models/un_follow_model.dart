class UnfollowResponse {
  final String message;

  UnfollowResponse({required this.message});

  factory UnfollowResponse.fromJson(Map<String, dynamic> json) {
    return UnfollowResponse(
      message: json['message'],
    );
  }
}
