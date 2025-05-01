import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:rommify_app/features/profile/data/models/update_profile_body.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../apis/profile_api_service.dart';
import '../models/get_follow_count_model.dart';
import '../models/get_profile_data.dart';
import '../models/un_follow_model.dart';
import '../models/update_profile_response.dart';

class ProfileRepo {
  final ProfileApiService _apiService;

  ProfileRepo(this._apiService);

  Future<Either<ErrorHandler, UnfollowResponse>> addFollow(
  {required String followId}) async {
    try {
      final response = await _apiService.addFollow( followId: followId);
      return  Right(UnfollowResponse.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
  Future<Either<ErrorHandler, UnfollowResponse>> unFollow(
      {required String followId}) async {
    try {
      final response = await _apiService.unFollow( followId: followId);
      return  Right(UnfollowResponse.fromJson(response.data));
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
      {required String updateProfileId,required UpdateProfileBody updateProfileBody,required File? imageProfile}) async {
    try {
      final response = await _apiService.updateProfile(updateProfileBody: updateProfileBody, profileId: updateProfileId, imageProfile: imageProfile);
      return  Right(UpdateProfileResponse.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
  Future<Either<ErrorHandler, GetProfileDataModel>> getProfileData(
      {required String profileId}) async {
    try {
      final response = await _apiService.getUserProfileData(profileId: profileId);
      return Right(GetProfileDataModel.fromJson(response.data));
    } catch (error) {
      print("errorrr ${error}");
      return Left(ErrorHandler.handle(error));
    }
  }
  Future<Either<ErrorHandler, GetFollowCountModel>> getFollowCount(
      {required String followId}) async {
    try {
      final response = await _apiService.getFollowCount(followId: followId);
      return  Right(GetFollowCountModel.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}