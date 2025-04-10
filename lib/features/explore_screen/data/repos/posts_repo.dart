
import 'package:either_dart/either.dart';
import 'package:rommify_app/features/explore_screen/data/apis/posts_api_service.dart';
import 'package:rommify_app/features/explore_screen/data/models/get_all_posts_response.dart';

import '../../../../core/networking/api_error_handler.dart';


class PostsRepo {
  final PostsApiService _postsApiService;

  PostsRepo(this._postsApiService);

  Future<Either<ErrorHandler,GetAllPostsResponse>> getAllPosts() async {
    try {
      final response = await _postsApiService.getAllPost();
      return Right(GetAllPostsResponse.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}
