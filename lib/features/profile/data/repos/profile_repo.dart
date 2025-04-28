import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../apis/profile_api_service.dart';

class ProfileRepo {
  final ProfileApiService _apiService;

  ProfileRepo(this._apiService);

  Future<Either<ErrorHandler, String>> addFollow(
  {required String followId}) async {
    try {
      final response = await _apiService.addFollow( followId: followId);
      print("OTP Response data: ${response.data}");
      return Right("Followed successfully.");
    } catch (error) {
      print("VerifyOTP Error: $error");
      return Left(ErrorHandler.handle(error));
    }
  }
  Future<Either<ErrorHandler, Response<dynamic>>> checkIsFollowing(
      {required String followId}) async {
    try {
      final response = await _apiService.checkIsFollow(followId: followId);
      print("OTP Response data: ${response.data}");
      return  Right(response);
    } catch (error) {
      print("VerifyOTP Error: $error");
      return Left(ErrorHandler.handle(error));
    }
  }

}