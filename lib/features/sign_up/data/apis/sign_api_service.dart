import 'package:dio/dio.dart';
import 'package:rommify_app/core/networking/api_networking.dart';
import 'package:rommify_app/features/sign_up/data/models/sign_request_body.dart';

class SignUpApiService {
  final Dio dio;
  SignUpApiService({required this.dio});

  Future<Response> signUp({
    required SignUpRequestBody signUpRequestBody
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.signUpUrl,
        data: signUpRequestBody.toJson()
      );
      return response;
    } catch (e) {
      print("API Error in signUp: $e");
      rethrow;
    }
  }
  
  Future<Response> verifyOtp({
    required OtpRequestBody otpRequestBody
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.verifyOtpUrl,
        data: otpRequestBody.toJson()
      );
      return response;
    } catch (e) {
      print("API Error in verifyOtp: $e");
      rethrow;
    }
  }
}