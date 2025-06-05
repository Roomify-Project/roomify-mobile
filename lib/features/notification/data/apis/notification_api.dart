
import 'package:dio/dio.dart';
import 'package:rommify_app/core/networking/api_networking.dart';
class NotificationApiService {
  final Dio dio;

  NotificationApiService({required this.dio});

  Future<Response> getAllNotification() async {
    try {
      final response = await dio.get(
        ApiConstants.getAllNotification,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

}
