import 'package:dio/dio.dart';
import 'package:rommify_app/core/networking/api_networking.dart';
import 'package:rommify_app/features/change_password/data/models/change_password_request_body.dart';
import 'package:rommify_app/features/change_password/data/models/change_password_response.dart';

import '../models/change_password_body.dart';


class ChangePasswordApiService {
  final Dio _dio;

  ChangePasswordApiService({required Dio dio}) : _dio = dio;

  Future<Response> changePassword(ChangePasswordBody request) async {
      final response = await _dio.post(
        ApiConstants.changePasswordUrl,
        data: request.toJson(),
      );
      
      return response;

  }
}