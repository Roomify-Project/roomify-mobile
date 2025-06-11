import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/networking/api_networking.dart';
import '../models/add_comment_body.dart';

class PostsApiService {
  final Dio dio;

  PostsApiService({required this.dio});

  Future<Response> getAllPost() async {
    final response = await dio.get(ApiConstants.getAllPostsUrl);
    return response;
  }

  Future<Response> getPostsUser({required String id}) async {
    final response = await dio.get(ApiConstants.getUserPostsUrl(id: id));
    return response;
  }

  Future<Response> getPost({required String postId}) async {
    final response = await dio.get(ApiConstants.getPost(id: postId));
    return response;
  }

  Future<Response> addPost({
    required String userId,
    required String description,
    required File imageFile,
  }) async {
    final formData = FormData.fromMap({
      'Description': description,
      'imageFile':
          await MultipartFile.fromFile(imageFile.path, filename: 'upload.jpg'),
      // لو فيه ملف:
      // 'image': await MultipartFile.fromFile('path/to/image.jpg', filename: 'image.jpg'),
    });
    final response =
        await dio.post(ApiConstants.addPost(userId: userId), data: formData);
    return response;
  }

  Future<Response> deletePost({required String postId}) async {
    final response = await dio.delete(ApiConstants.getPost(id: postId));
    return response;
  }

  Future<Response> getCommentPost({required String postId}) async {
    final response = await dio.get(
      ApiConstants.getCommentPost(postId: postId),
    );
    return response;
  }

  Future<Response> addComment(
      {required AddCommentBody addCommentBody, required String userId}) async {
    // final formData = FormData.fromMap({
    //   'content':addCommentBody.content,
    //   'PortfolioPostId': addCommentBody.portfolioPostId,
    //   // لو فيه ملف:
    //   // 'image': await MultipartFile.fromFile('path/to/image.jpg', filename: 'image.jpg'),
    // });
    final response = await dio.post(ApiConstants.addComment, data: {
      'content': addCommentBody.content,
      'PortfolioPostId': addCommentBody.portfolioPostId,
    }, queryParameters: {
      'userId': userId,
    });
    return response;
  }

  Future<Response> updateComment({
    required String userId,
    required String commentId,
    required String content,
  }) async {
    final response =
        await dio.put(ApiConstants.updateComment(commentId: commentId), data: {
      'content': content,
    }, queryParameters: {
      'userId': userId,
    });
    return response;
  }

  Future<Response> deleteComment(
      {required String userId, required String commentId}) async {
    final response = await dio.delete(
        ApiConstants.deleteComment(commentId: commentId),
        queryParameters: {
          'userId': userId,
        });
    return response;
  }

  Future<Response?> download({required String imageUrl}) async {
    Permission permission;

    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      if (deviceInfo.version.sdkInt >= 33) {
        // Android 13+ uses granular media permissions
        permission = Permission.photos;
      } else {
        // Android 12 and below
        permission = Permission.storage;
      }
    } else {
      // iOS
      permission = Permission.photos;
    }

    final status = await permission.request();

    if (!status.isGranted) {
      print("❌ Permission denied for ${permission.toString()}");

      // Show settings dialog if permanently denied
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
      return null;
    }
    print("downloaddd");

    final response = await dio.get(
      ApiConstants.download,
      queryParameters: {
        'imageUrl': imageUrl,
      },
      options: Options(
        responseType: ResponseType.bytes,
      ),

      //   options: Options(
      //   headers: {
      //     'Content-Type': 'multipart/form-data',
      //   },
      // )
    );
    final Uint8List imageData = Uint8List.fromList(response.data);

    // حفظ الصورة في المعرض
    final result = await ImageGallerySaver.saveImage(
      imageData,
      quality: 100,
      name: "downloaded_image_${DateTime.now().millisecondsSinceEpoch}",
    );
    if (result['isSuccess'] == true || result['success'] == true) {
      print("✅ Image saved successfully");
    } else {
      print("❌ Failed to save image");
    }
    return response;
  }

  Future<Response> saveDesign(
      {required String userId, required String imageUrl}) async {
    final formData = FormData.fromMap({
      'imageUrl': imageUrl,
      'userId':userId,
      // لو فيه ملف:
      // 'image': await MultipartFile.fromFile('path/to/image.jpg', filename: 'image.jpg'),
    });
    final response = await dio.post(
      ApiConstants.saveDesign,
      data: formData,
    );
    return response;
  }
  Future<Response> getAllChats() async {
    final response= await dio.get(ApiConstants.getAllChats);
    return  response;
  }
  Future<Response> searchUsers({required String query}) async {
    final response= await dio.get(ApiConstants.searchUsers,queryParameters: {
      'query':query
    });
    return  response;
  }
}
