import 'package:dio/dio.dart';
import 'package:rommify_app/core/networking/api_networking.dart';
import 'package:rommify_app/features/log_in/data/models/login_request_body.dart';
class LoginApiService {
  final Dio dio;
  LoginApiService({required this.dio});
  Future<Response> login({
    required LoginRequestBody loginRequestBody
}) async {
   final response= await dio.post(ApiConstants.loginUrl,data: {
     'email':loginRequestBody.email,
     'password':loginRequestBody.password,
   });
     return  response;
  }
}
