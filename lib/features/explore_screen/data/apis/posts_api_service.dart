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
      {required AddCommentBody addCommentBody,
      required String userId,
      required bool isPost}) async {
    // final formData = FormData.fromMap({
    //   'content':addCommentBody.content,
    //   'PortfolioPostId': addCommentBody.portfolioPostId,
    //   // لو فيه ملف:
    //   // 'image': await MultipartFile.fromFile('path/to/image.jpg', filename: 'image.jpg'),
    // });
    final response = await dio.post(ApiConstants.addComment, data: {
      'content': addCommentBody.content,
      isPost ? 'PortfolioPostId' : 'savedDesignId':
          addCommentBody.portfolioPostId,
      'userId': userId
    }, queryParameters: {
      'userId': userId,
    });
    return response;
  }

  Future<Response> addLike(
      {required String userId,
      required bool isPost,
      required String postId}) async {
    // final formData = FormData.fromMap({
    //   'content':addCommentBody.content,
    //   'PortfolioPostId': addCommentBody.portfolioPostId,
    //   // لو فيه ملف:
    //   // 'image': await MultipartFile.fromFile('path/to/image.jpg', filename: 'image.jpg'),
    // });
    final response =
        await dio.post(ApiConstants.addLike(postId: postId), queryParameters: {
      'userId': userId,
      'isPost': isPost,
    });
    return response;
  }

  Future<Response> removeLike(
      {required String userId,
        required bool isPost,
        required String postId}) async {
    // final formData = FormData.fromMap({
    //   'content':addCommentBody.content,
    //   'PortfolioPostId': addCommentBody.portfolioPostId,
    //   // لو فيه ملف:
    //   // 'image': await MultipartFile.fromFile('path/to/image.jpg', filename: 'image.jpg'),
    // });
    final response =
    await dio.delete(ApiConstants.addLike(postId: postId), queryParameters: {
      'userId': userId,
      'isPost': isPost,
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

  // Future<void> downloadImage({required String imageUrl}) async {
  //   try {
  //     // محاولة تحميل الصورة وحفظها في المعرض
  //     final imageId = await ImageDownloader.downloadImage(
  //       imageUrl,
  //       destination: AndroidDestinationType.directoryPictures
  //         ..subDirectory("MyAppImages/image_${DateTime.now().millisecondsSinceEpoch}.jpg"),
  //     );
  //
  //     if (imageId == null) {
  //       print("❌ فشل في تحميل الصورة");
  //     } else {
  //       print("✅ تم تحميل الصورة وحفظها بنجاح");
  //     }
  //   } catch (e) {
  //     print("❌ حصل خطأ أثناء تحميل الصورة: $e");
  //   }
  // }

  Future<Response?> download({required String imageUrl}) async {
    try {
      // التحقق من الصلاحيات مرة واحدة فقط عند بداية التطبيق
      if (!await _checkPermissions()) {
        return null;
      }

      // تحميل مباشر بدون استعلام API إضافي
      final response = await dio.get(
        imageUrl, // استخدام الرابط مباشرة بدلاً من API
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 30), // تحديد timeout
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      // حفظ مباشر بدون تحويل إضافي
      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 85, // تقليل الجودة قليلاً للسرعة (اختياري)
        name: "img_${DateTime.now().millisecondsSinceEpoch}",
        isReturnImagePathOfIOS: false, // تسريع على iOS
      );

      if (result['isSuccess'] == true || result['success'] == true) {
        print("✅ Image saved successfully");
        return response;
      } else {
        print("❌ Failed to save image");
        return null;
      }
    } catch (e) {
      print("❌ Download error: $e");
      return null;
    }
  }

// دالة منفصلة للتحقق من الصلاحيات (تستدعى مرة واحدة)
  Future<bool> _checkPermissions() async {
    Permission permission;

    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      permission = deviceInfo.version.sdkInt >= 33
          ? Permission.photos
          : Permission.storage;
    } else {
      permission = Permission.photos;
    }

    final status = await permission.status;

    if (status.isGranted) return true;

    if (status.isDenied) {
      final newStatus = await permission.request();
      if (newStatus.isGranted) return true;
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }

    return false;
  }

// للتحميل المتعدد (أسرع للصور المتعددة)
  Future<List<bool>> downloadMultiple(List<String> imageUrls) async {
    if (!await _checkPermissions()) {
      return List.filled(imageUrls.length, false);
    }

    final results = await Future.wait(
      imageUrls.map((url) => _downloadSingle(url)),
      eagerError: false, // متابعة حتى لو فشل أحدها
    );

    return results;
  }

  Future<bool> _downloadSingle(String imageUrl) async {
    try {
      final response = await dio.get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 85,
        name:
            "img_${DateTime.now().millisecondsSinceEpoch}_${imageUrl.hashCode}",
      );

      return result['isSuccess'] == true || result['success'] == true;
    } catch (e) {
      print("❌ Single download error: $e");
      return false;
    }
  }

  Future<Response> saveDesign(
      {required String userId, required String imageUrl}) async {
    final formData = FormData.fromMap({
      'imageUrl': imageUrl,
      'userId': userId,
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
    final response = await dio.get(ApiConstants.getAllChats);
    return response;
  }

  Future<Response> searchUsers({required String query}) async {
    final response = await dio
        .get(ApiConstants.searchUsers, queryParameters: {'query': query});
    return response;
  }
}
