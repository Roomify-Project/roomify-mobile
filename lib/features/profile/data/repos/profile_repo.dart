import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:rommify_app/features/profile/data/models/update_profile_body.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../apis/profile_api_service.dart';
import '../models/update_profile_response.dart';

class ProfileRepo {
  final ProfileApiService _apiService;

  ProfileRepo(this._apiService);

  Future<Either<ErrorHandler, String>> addFollow(
  {required String followId}) async {
    try {
      final response = await _apiService.addFollow( followId: followId);
      return const Right("Followed successfully.");
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
  Future<Either<ErrorHandler, Response<dynamic>>> checkIsFollowing(
      {required String followId}) async {
    try {
      final response = await _apiService.checkIsFollow(followId: followId);
      return  Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
  Future<Either<ErrorHandler, UpdateProfileResponse>> updateProfile(
      {required String updateProfileId,required UpdateProfileBody updateProfileBody}) async {
    try {
      final response = await _apiService.updateProfile(updateProfileBody: updateProfileBody, profileId: updateProfileId);
      return  Right(UpdateProfileResponse.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

}