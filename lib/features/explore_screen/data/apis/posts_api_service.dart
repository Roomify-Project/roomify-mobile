import 'package:dio/dio.dart';
import 'package:rommify_app/core/networking/api_networking.dart';
import 'package:rommify_app/core/networking/dio_factory.dart';
import 'package:rommify_app/features/log_in/data/models/login_request_body.dart';

import '../models/get_posts_response.dart';

class PostsApiService {
  final Dio dio;
  PostsApiService({required this.dio});
  Future<Response> getAllPost() async {
   final response= await dio.get(ApiConstants.getAllPostsModel);
     return  response;
  }
  Future<Response> getPostsUser({required String id}) async {
    final response= await dio.get(ApiConstants.getUserPostsModel(id: id));
    return  response;
  }
}
