import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rommify_app/core/networking/api_networking.dart';
import 'package:rommify_app/features/profile/data/models/update_profile_body.dart';


class ProfileApiService {
  final Dio dio;

  ProfileApiService({required this.dio});

  Future<Response> addFollow({required String followId}) async {
    try {
      final response = await dio.post(
        ApiConstants.addFollowUrl(followId: followId),
        data: {},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }


  Future<Response> unFollow({required String followId}) async {
    try {
      final response = await dio.delete(
        ApiConstants.deleteFollowUrl(followId: followId),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> checkIsFollow({required String followId}) async {
    try {
      final response = await dio.get(
        ApiConstants.getIsFollowingUrl(followId: followId),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
  Future<Response> updateProfile({required UpdateProfileBody updateProfileBody,required String profileId,required File? imageProfile}) async {
    try {
      final formData = FormData.fromMap({
        'UserName': updateProfileBody.userName,
        'FullName': updateProfileBody.fullName,
        'Bio': updateProfileBody.bio,
        'Email': updateProfileBody.email,
        if(imageProfile!=null)
        'ProfileImage':await MultipartFile.fromFile(imageProfile.path, filename: 'upload.jpg'),
      });
      final response = await dio.put(
        ApiConstants.updateProfile,
        data: formData,
          options: Options(
            headers: {
              'Content-Type': 'multipart/form-data',
            },
          )
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getUserProfileData({required String profileId}) async {
    try {
      final response = await dio.get(
        ApiConstants.getProfileData( profileId: profileId),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getFollowCount({required String followId}) async {
    try {
      final response = await dio.get(
        ApiConstants.getFollowCount(followId: followId),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
  Future<Response> getHistory({required String userId}) async {
    try {
      final response = await dio.get(
        ApiConstants.getHistory(userId: userId),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
  Future<Response> getSavedDesign({required String userId}) async {
    try {
      final response = await dio.get(
        ApiConstants.getSavedDesign(userId: userId),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
  Future<Response> getFollowingList({required String userId}) async {
    try {
      final response = await dio.get(
        ApiConstants.getFollowingList(userId: userId),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
  Future<Response> getFollowersList({required String userId}) async {
    try {
      final response = await dio.get(
        ApiConstants.getFollowersList(userId: userId),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
