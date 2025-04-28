import 'package:dio/dio.dart';
import 'package:rommify_app/core/networking/api_networking.dart';
import 'package:rommify_app/features/sign_up/data/models/sign_request_body.dart';

class ProfileApiService {
  final Dio dio;
  ProfileApiService({required this.dio});


  Future<Response> addFollow({
    required String followId
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.addFollowUrl(followId: followId),
        data:{},
      );
      return response;
    } catch (e) {
      print("API Error in verifyOtp: $e");
      rethrow;
    }
  }

  Future<Response> checkIsFollow({    required String followId
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.getIsFollowingUrl(followId: followId),
        data:{},
      );
      return response;
    } catch (e) {
      print("API Error in verifyOtp: $e");
      rethrow;
    }
  }
}