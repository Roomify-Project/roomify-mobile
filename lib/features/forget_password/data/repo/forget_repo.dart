// forget_repo.dart

import 'package:either_dart/either.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../apis/forget_api_service.dart';
import '../models/forget_request_body.dart';
import '../models/forget_response.dart';

class ForgetPasswordRepo {
  final ForgetPasswordApiService _apiService;

  ForgetPasswordRepo(this._apiService);

  Future<Either<ErrorHandler, ForgetPasswordResponse>> sendOtp(
      ForgetPasswordRequestBody requestBody) async {
    try {
      final response = await _apiService.sendOtp(requestBody: requestBody);
      return Right(ForgetPasswordResponse.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  Future<Either<ErrorHandler, ForgetPasswordResponse>> verifyOtp(
      ForgetPasswordOtpRequestBody requestBody) async {
    try {
      final response = await _apiService.verifyOtp(otpRequestBody: requestBody);
      return Right(ForgetPasswordResponse.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  Future<Either<ErrorHandler, ResetPasswordResponse>> resetPassword(
      ResetPasswordRequestBody requestBody) async {
    try {
      final response = await _apiService.resetPassword(requestBody: requestBody);
      return Right(ResetPasswordResponse.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}