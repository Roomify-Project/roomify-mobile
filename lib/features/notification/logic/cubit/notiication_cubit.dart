import 'dart:async';
import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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


}