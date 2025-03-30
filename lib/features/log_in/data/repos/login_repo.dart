// import 'package:christy/core/networking/api_error_handler.dart';
// import 'package:christy/core/networking/api_result.dart';
// import 'package:christy/features/login/data/apis/login_api_service.dart';
// import 'package:christy/features/login/data/models/login_request_body.dart';

import 'package:either_dart/either.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';
import '../apis/login_api_service.dart';
import '../models/login_request_body.dart';
import '../models/login_response.dart';

class LoginRepo {
  final LoginApiService _apiService;

  LoginRepo(this._apiService);

  Future<Either<ErrorHandler,LoginResponse>> login(
      LoginRequestBody loginRequestBody) async {
    try {
      final response = await _apiService.login(loginRequestBody: loginRequestBody);
      return Right(LoginResponse.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}
