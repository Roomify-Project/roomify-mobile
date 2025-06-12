
import 'dart:io';

import 'package:either_dart/either.dart';

import 'package:rommify_app/features/explore_screen/data/apis/posts_api_service.dart';
import 'package:rommify_app/features/explore_screen/data/models/get_omment_model.dart';
import 'package:rommify_app/features/explore_screen/data/models/get_posts_response.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../../../profile/data/models/get_all_chats_response.dart';
import '../../../profile/data/models/pust_save_design.dart';
import '../models/add_comment_body.dart';
import '../models/add_post_nodel.dart';
import '../models/create_comment_model.dart';
import '../models/delete_comment_response.dart';
import '../models/delete_post_Response.dart';
import '../models/get_post_model.dart';
import '../models/get_user_post_response.dart';
import '../models/like_response.dart';
import '../models/save_design_response.dart';
import '../models/search_user_model.dart';


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
  Future<Either<ErrorHandler,GetUserPost>> getUserPosts({required String id}) async {
    try {
      final response = await _postsApiService.getPostsUser(id: id);
      return Right(GetUserPost.fromJson(response.data));
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

  Future<Either<ErrorHandler,DeletePostResponse>> deletePost({required String postId
  }) async {
    try {
      final response = await _postsApiService.deletePost(postId: postId);
      return Right(DeletePostResponse.fromJson(response.data));
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
  Future<Either<ErrorHandler,CreateCommentModel>> addComment({required AddCommentBody addCommentBody,required String userId,  required bool isPost

  }) async {
    try {
      final response = await _postsApiService.addComment(addCommentBody: addCommentBody, userId: userId, isPost: isPost);
      return Right(CreateCommentModel.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
  Future<Either<ErrorHandler,LikeResponse>> addLike({required String userId,  required bool isPost,required String postId

  }) async {
    try {
      final response = await _postsApiService.addLike( userId: userId, isPost: isPost, postId: postId);
      return Right(LikeResponse.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  Future<Either<ErrorHandler,String>> removeLike({required String userId,  required bool isPost,required String postId

  }) async {
    try {
      final response = await _postsApiService.removeLike( userId: userId, isPost: isPost, postId: postId);
      return const Right("removed Successfully");
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


  Future<Either<ErrorHandler,PutSavedDesign>> saveDesign({required String imageUrl,
    required String userId
  }) async {
    try {
      final response = await _postsApiService.saveDesign(imageUrl: imageUrl, userId: userId);


      return  Right(PutSavedDesign.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
  Future<Either<ErrorHandler,GetAllChatResponse>> getAllChats() async {
    try {
      final response = await _postsApiService.getAllChats();
      return  Right(GetAllChatResponse.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
  Future<Either<ErrorHandler,SearchUserModel>> searchUser({required String query}) async {
    try {
      final response = await _postsApiService.searchUsers(query: query);
      return  Right(SearchUserModel.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}
