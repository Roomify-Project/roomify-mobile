
import 'package:either_dart/either.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../apis/notification_api.dart';
import '../model/notification_model.dart';


class NotificationRepo {
  final NotificationApiService _apiService;

  NotificationRepo(this._apiService);

  Future<Either<ErrorHandler, NotificationModel>> getAllNotification() async {
    try {
      final response = await _apiService.getAllNotification();
      return  Right(NotificationModel.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

}