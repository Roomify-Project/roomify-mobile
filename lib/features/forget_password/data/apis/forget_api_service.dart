// forget_api_service.dart

import 'package:dio/dio.dart';
import '../../../../core/networking/api_networking.dart';
import '../models/forget_request_body.dart';

class ForgetPasswordApiService {
  final Dio dio;
  ForgetPasswordApiService({required this.dio});

  Future<Response> sendOtp({
    required ForgetPasswordRequestBody requestBody
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.forgetPasswordUrl,
        data: requestBody.toJson()
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> verifyOtp({
    required ForgetPasswordOtpRequestBody otpRequestBody
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.verifyOtpUrl,
        data: otpRequestBody.toJson()
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> resetPassword({
    required ResetPasswordRequestBody requestBody
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.resetPasswordUrl,
        data: requestBody.toJson()
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}