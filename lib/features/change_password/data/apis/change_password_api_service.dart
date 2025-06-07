import 'package:dio/dio.dart';

import '../../../../core/networking/api_networking.dart';
import '../models/change_password_body.dart';

class ChangePasswordApiService {
  final Dio dio;

  ChangePasswordApiService({required this.dio});

  Future<Response> changePassword(ChangePasswordBody body) async {
    try {
      final response = await dio.post(
        ApiConstants.changePasswordUrl,
        data: body.toJson(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}