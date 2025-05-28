
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rommify_app/features/explore_screen/data/apis/posts_api_service.dart';
import 'package:rommify_app/features/explore_screen/data/models/get_omment_model.dart';
import 'package:rommify_app/features/explore_screen/data/models/get_posts_response.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../models/add_comment_body.dart';
import '../models/add_post_nodel.dart';
import '../models/delete_comment_response.dart';
import '../models/get_post_model.dart';
import '../models/save_design_response.dart';


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
  Future<Either<ErrorHandler,GetCommentResponse>> getCommentPost({required String postId}) async {
    try {
      final response = await _postsApiService.getCommentPost(postId: postId);
      return Right(GetCommentResponse.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
  Future<Either<ErrorHandler,CommentData>> addComment({required AddCommentBody addCommentBody,required String userId
  }) async {
    try {
      final response = await _postsApiService.addComment(addCommentBody: addCommentBody, userId: userId);
      return Right(CommentData.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  Future<Either<ErrorHandler,CommentData>> updateComment({required String userId,required String commentId,  required String content,
  }) async {
    try {
      final response = await _postsApiService.updateComment(userId: userId, commentId: commentId, content: content);
      return Right(CommentData.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
  Future<Either<ErrorHandler,DeleteCommentResponse>> deleteComment({required String userId,required String commentId
  }) async {
    try {
      final response = await _postsApiService.deleteComment(userId: userId, commentId: commentId);
      return Right(DeleteCommentResponse.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  Future<Either<ErrorHandler,String>> download({required String imageUrl
  }) async {
    try {
      final response = await _postsApiService.download(imageUrl: imageUrl);


      return const Right("download success");
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }


  Future<Either<ErrorHandler,SavedDesignResponse>> saveDesign({required String imageUrl,
    required String userId
  }) async {
    try {
      final response = await _postsApiService.saveDesign(imageUrl: imageUrl, userId: userId);


      return  Right(SavedDesignResponse.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}
