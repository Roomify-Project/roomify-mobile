
import 'dart:io';

import 'package:either_dart/either.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../apis/generate_api_service.dart';
import '../models/generate_body.dart';
import '../models/generate_image_response.dart';
class GenerateRepo {
  final GenerateApiService _generateApiService;

  GenerateRepo(this._generateApiService);

  Future<Either<ErrorHandler,GeneratedImagesResponse>> generate({required GenerateBodyModel generateBodyModel ,  required File imageFile,
  }) async {
    try {
      final response = await _generateApiService.generate(imageFile: imageFile, generateBody: generateBodyModel);
      return Right(GeneratedImagesResponse.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }



}
