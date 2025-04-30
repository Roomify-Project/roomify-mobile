
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:rommify_app/features/explore_screen/data/apis/posts_api_service.dart';
import 'package:rommify_app/features/explore_screen/data/models/get_posts_response.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../models/add_post_nodel.dart';
import '../models/get_post_model.dart';


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

  Future<Either<ErrorHandler,GetPostResponse>> getPost({required String postId}) async {
    try {
      final response = await _postsApiService.getPost(postId: postId);
      return Right(GetPostResponse.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
  Future<Either<ErrorHandler,AddPostResponse>> addPost({required String userId,required String description ,  required File imageFile,
  }) async {
    try {
      final response = await _postsApiService.addPost(userId: userId, description: description, imageFile: imageFile);
      return Right(AddPostResponse.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  Future<Either<ErrorHandler,AddPostResponse>> deletePost({required String postId
  }) async {
    try {
      final response = await _postsApiService.deletePost(postId: postId);
      return Right(AddPostResponse.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

}
