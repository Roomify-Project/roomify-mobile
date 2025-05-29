abstract class NotificationState {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationConnected extends NotificationState {
  final List<Map<String, dynamic>> unreadNotifications;
  final int unreadCount;

  const NotificationConnected({
    required this.unreadNotifications,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [unreadNotifications, unreadCount];
}

class NotificationDisconnected extends NotificationState {
  final String error;

  const NotificationDisconnected({required this.error});

  @override
  List<Object?> get props => [error];
}

class NotificationReceived extends NotificationState {
  final Map<String, dynamic> notification;
  final List<Map<String, dynamic>> allUnreadNotifications;
  final int unreadCount;

  const NotificationReceived({
    required this.notification,
    required this.allUnreadNotifications,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [notification, allUnreadNotifications, unreadCount];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError({required this.message});

  @override
  List<Object?> get props => [message];
}