// import 'package:christy/core/networking/api_error_handler.dart';
// import 'package:christy/core/networking/api_result.dart';
// import 'package:christy/features/login/data/apis/login_api_service.dart';
// import 'package:christy/features/login/data/models/login_request_body.dart';
//
// import '../models/login_response.dart';
//
// class LoginRepo {
//   final LoginApiService _apiService;
//
//   LoginRepo(this._apiService);
//
//   Future<ApiResult<LoginResponse>> login(
//       LoginRequestBody loginRequestBody) async {
//     try {
//       final response = await _apiService.login(loginRequestBody);
//       return ApiResult.success(response);
//     } catch (error) {
//       return ApiResult.failure(ErrorHandler.handle(error));
//     }
//   }
// }
