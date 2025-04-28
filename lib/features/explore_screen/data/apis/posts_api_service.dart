import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rommify_app/core/networking/api_networking.dart';
import 'package:rommify_app/core/networking/dio_factory.dart';
import 'package:rommify_app/features/log_in/data/models/login_request_body.dart';

import '../models/get_posts_response.dart';

class PostsApiService {
  final Dio dio;
  PostsApiService({required this.dio});
  Future<Response> getAllPost() async {
   final response= await dio.get(ApiConstants.getAllPostsUrl);
     return  response;
  }
  Future<Response> getPostsUser({required String id}) async {
    final response= await dio.get(ApiConstants.getUserPostsUrl(id: id));
    return  response;
  }
  Future<Response> getPost({required String postId}) async {
    final response= await dio.get(ApiConstants.getPost(id: postId));
    return  response;
  }
  Future<Response> addPost({required String userId,required String description,  required File imageFile,
  }) async {
    final formData = FormData.fromMap({
      'Description': description,
      'imageFile': await MultipartFile.fromFile(imageFile.path, filename: 'upload.jpg'),
      // لو فيه ملف:
      // 'image': await MultipartFile.fromFile('path/to/image.jpg', filename: 'image.jpg'),
    });
    final response= await dio.post(ApiConstants.addPost(userId: userId),data: formData);
    return  response;
  }
  Future<Response> deletePost({required String postId}) async {
    final response= await dio.delete(ApiConstants.getPost(id: postId));
    return  response;
  }
}
