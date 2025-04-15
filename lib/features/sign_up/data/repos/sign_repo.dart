import 'package:either_dart/either.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../apis/sign_api_service.dart';
import '../models/sign_request_body.dart';
import '../models/sign_response.dart';

class SignUpRepo {
  final SignUpApiService _apiService;

  SignUpRepo(this._apiService);

  Future<Either<ErrorHandler, SignUpResponse>> signUp(
      SignUpRequestBody signUpRequestBody) async {
    try {
      final response = await _apiService.signUp(signUpRequestBody: signUpRequestBody);
      return Right(SignUpResponse.fromJson(response.data));
    } catch (error) {
      print("SignUp Error: $error");
      return Left(ErrorHandler.handle(error));
    }
  }
  
  Future<Either<ErrorHandler, OtpResponse>> verifyOtp(
      OtpRequestBody otpRequestBody) async {
    try {
      final response = await _apiService.verifyOtp(otpRequestBody: otpRequestBody);
      print("OTP Response data: ${response.data}");
      return Right(OtpResponse.fromJson(response.data));
    } catch (error) {
      print("VerifyOTP Error: $error");
      return Left(ErrorHandler.handle(error));
    }
  }
}