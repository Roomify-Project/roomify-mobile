class NotificationModel {
  final bool status;
  final String message;
  final List<dynamic> data;

  NotificationModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
    };
  }
}
