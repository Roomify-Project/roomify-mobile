// import 'dart:async';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../core/widgets/signal_r_notification.dart';
// import 'notification_states.dart';
//
// // States
//
//
// // Cubit
// class NotificationCubit extends Cubit<NotificationState> {
//   StreamSubscription<Map<String, dynamic>>? _notificationSubscription;
//
//   NotificationCubit() : super(NotificationInitial());
//
//   Future<void> initializeNotifications() async {
//     try {
//       emit(NotificationLoading());
//
//       // تهيئة الخدمة
//       await NotificationSignalRService.initializeNotificationConnection();
//
//       // الاستماع للإشعارات الجديدة
//       _listenToNotifications();
//
//       // إرسال الحالة الأولية
//       emit(NotificationConnected(
//         unreadNotifications: NotificationSignalRService.unreadNotifications,
//         unreadCount: NotificationSignalRService.unreadCount,
//       ));
//
//     } catch (error) {
//       emit(NotificationError(message: error.toString()));
//     }
//   }
//
//   void _listenToNotifications() {
//     print("listennnn");
//     _notificationSubscription?.cancel();
//     _notificationSubscription = NotificationSignalRService.notificationStream.listen(
//           (notificationData) {
//         _handleNotificationReceived(notificationData);
//       },
//       onError: (error) {
//         emit(NotificationError(message: error.toString()));
//       },
//     );
//   }
//
//   void _handleNotificationReceived(Map<String, dynamic> notificationData) {
//     // التحقق من نوع الإشعار
//     if (notificationData['type'] == 'notification_clicked') {
//       // معالجة النقر على الإشعار
//       _handleNotificationClick(notificationData['payload']);
//       return;
//     }
//
//     // إشعار جديد
//     emit(NotificationReceived(
//       notification: notificationData,
//       allUnreadNotifications: NotificationSignalRService.unreadNotifications,
//       unreadCount: NotificationSignalRService.unreadCount,
//     ));
//   }
//
//   void _handleNotificationClick(String? payload) {
//     // يمكنك هنا إضافة منطق للتنقل لصفحة معينة
//     // بناءً على محتوى الإشعار
//     print('Handling notification click: $payload');
//
//     // مثال: إرسال event للـ UI
//     // Navigator.pushNamed(context, '/notifications');
//   }
//
//   Future<void> markNotificationAsRead(String notificationId) async {
//     try {
//       await NotificationSignalRService.markNotificationAsRead(notificationId);
//
//       // تحديث الحالة
//       emit(NotificationConnected(
//         unreadNotifications: NotificationSignalRService.unreadNotifications,
//         unreadCount: NotificationSignalRService.unreadCount,
//       ));
//     } catch (error) {
//       emit(NotificationError(message: error.toString()));
//     }
//   }
//
//   Future<void> markAllNotificationsAsRead() async {
//     try {
//       await NotificationSignalRService.markAllNotificationsAsRead();
//
//       // تحديث الحالة
//       emit(NotificationConnected(
//         unreadNotifications: NotificationSignalRService.unreadNotifications,
//         unreadCount: NotificationSignalRService.unreadCount,
//       ));
//     } catch (error) {
//       emit(NotificationError(message: error.toString()));
//     }
//   }
//
//   Future<void> reconnectNotifications() async {
//     try {
//       emit(NotificationLoading());
//       await NotificationSignalRService.reconnectNotifications();
//
//       emit(NotificationConnected(
//         unreadNotifications: NotificationSignalRService.unreadNotifications,
//         unreadCount: NotificationSignalRService.unreadCount,
//       ));
//     } catch (error) {
//       emit(NotificationError(message: error.toString()));
//     }
//   }
//
//   // الحصول على عدد الإشعارات غير المقروءة
//   int get unreadCount => NotificationSignalRService.unreadCount;
//
//   // الحصول على قائمة الإشعارات غير المقروءة
//   List<Map<String, dynamic>> get unreadNotifications =>
//       NotificationSignalRService.unreadNotifications;
//
//   // التحقق من حالة الاتصال
//   bool get isConnected => NotificationSignalRService.isNotificationConnected;
//
//   @override
//   Future<void> close() {
//     _notificationSubscription?.cancel();
//     return super.close();
//   }
// }