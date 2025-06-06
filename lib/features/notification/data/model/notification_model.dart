class NotificationModel {
  final bool status;
  final String message;
  final List<NotificationData> notificationData;

  NotificationModel({
    required this.status,
    required this.message,
    required this.notificationData,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      status: json['status'],
      message: json['message'],
      notificationData: json['data'] != null
          ? List<NotificationData>.from(json['data'].map((v) => NotificationData.fromJson(v)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': notificationData.map((v) => v.toJson()).toList(),
    };
  }
}

class NotificationData {
  final String id;
  final String recipientUserId;
  final String type;
  final String message;
  final bool isRead;
  final String createdAt;
  final String? relatedEntityId;

  NotificationData({
    required this.id,
    required this.recipientUserId,
    required this.type,
    required this.message,
    required this.isRead,
    required this.createdAt,
     this.relatedEntityId,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'],
      recipientUserId: json['recipientUserId'],
      type: json['type'],
      message: json['message'],
      isRead: json['isRead'],
      createdAt: json['createdAt'],
      relatedEntityId: json['relatedEntityId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipientUserId': recipientUserId,
      'type': type,
      'message': message,
      'isRead': isRead,
      'createdAt': createdAt,
      'relatedEntityId': relatedEntityId,
    };
  }
}
