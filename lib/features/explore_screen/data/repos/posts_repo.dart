
import 'package:either_dart/either.dart';
import 'package:rommify_app/features/explore_screen/data/apis/posts_api_service.dart';
import 'package:rommify_app/features/explore_screen/data/models/get_posts_response.dart';

import '../../../../core/networking/api_error_handler.dart';


class PostsRepo {
  final PostsApiService _postsApiService;

  PostsRepo(this._postsApiService);

  Future<Either<ErrorHandler,GetPostsResponse>> getAllPosts() async {
    try {
      final response = await _postsApiService.getAllPost();
      return Right(GetPostsResponse.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
  Future<Either<ErrorHandler,GetPostsResponse>> getUserPosts({required String id}) async {
    try {
      final response = await _postsApiService.getPostsUser(id: id);
      return Right(GetPostsResponse.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}
