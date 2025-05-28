import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rommify_app/core/networking/api_networking.dart';

import '../models/generate_body.dart';
class GenerateApiService {
  final Dio dio;
  GenerateApiService({required this.dio});

  Future<Response> generate({required GenerateBodyModel generateBody,  required File imageFile,
  }) async {
    final formData = FormData.fromMap({
      'descriptionText': generateBody.descriptionText ,
      'image': await MultipartFile.fromFile(imageFile.path, filename: 'upload.jpg'),
      'roomStyle':generateBody.roomStyle,
      'roomType':generateBody.roomType,
      'userId':generateBody.userId
      // لو فيه ملف:
      // 'image': await MultipartFile.fromFile('path/to/image.jpg', filename: 'image.jpg'),
    });
    final response= await dio.post(ApiConstants.generate,data: formData,
    //   options: Options(
    //   headers: {
    //     'Content-Type': 'multipart/form-data',
    //   },
    // )
      );
    return  response;
  }

}
