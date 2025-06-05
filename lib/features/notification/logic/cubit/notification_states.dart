abstract class NotificationState {
}

class NotificationInitial extends NotificationState {}
class NotificationLoading extends NotificationState {}
class GetNotificationSuccess extends NotificationState {}
class GetNotificationError extends NotificationState {

  final String message;

  GetNotificationError({required this.message});
}
