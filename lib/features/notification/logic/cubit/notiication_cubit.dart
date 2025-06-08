import 'dart:async';
import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/signal_r_notification.dart';
import '../../data/model/notification_model.dart';
import '../../data/repo/notification_repo.dart';
import 'notification_states.dart';

// States


// Cubit
class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepo notificationRepo;
  NotificationModel? notificationModel;
  NotificationCubit(this.notificationRepo) : super(NotificationInitial());
  static NotificationCubit get(context) => BlocProvider.of<NotificationCubit>(context);

  Future<void> getAllNotification() async {
      emit(NotificationLoading());
      final response=await notificationRepo.getAllNotification();
      response.fold((left) {
        emit(GetNotificationError(message: left.apiErrorModel.title));

      }, (right) {
        notificationModel=right;
        emit(GetNotificationSuccess());
      },);


  }
  String formatChatTime(String timeString) {
    final dateTime = DateTime.parse(timeString);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final diff = now.difference(dateTime);

    final timeFormat = DateFormat.jm(); // Example: 9:00 AM

    if (messageDate == today) {
      return "Today ${timeFormat.format(dateTime)}";
    } else if (messageDate == yesterday) {
      return "Yesterday ${timeFormat.format(dateTime)}";
    } else if (diff.inDays < 7) {
      return "${DateFormat.EEEE().format(dateTime)} ${timeFormat.format(dateTime)}"; // e.g. Monday 3:00 PM
    } else if (diff.inDays < 14) {
      return "Last week";
    } else {
      return DateFormat.yMd().add_jm().format(dateTime); // e.g. 6/5/2025 12:38 PM
    }
  }



}