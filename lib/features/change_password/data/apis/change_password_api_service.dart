// import 'package:dio/dio.dart';
// import 'package:rommify_app/core/networking/api_networking.dart';
// import 'package:rommify_app/features/change_password/data/models/change_password_request_body.dart';
// import 'package:rommify_app/features/change_password/data/models/change_password_response.dart';


// class ChangePasswordApiService {
//   final Dio _dio;

//   ChangePasswordApiService({required Dio dio}) : _dio = dio;

//   Future<ChangePasswordResponse> changePassword(ChangePasswordRequestModel request) async {
//     try {
//       final response = await _dio.post(
//         ApiConstants.changePasswordUrl,
//         data: request.toJson(),
//       );
      
//       return ChangePasswordResponse.fromJson(response.data);
//     } on DioException catch (e) {
//       if (e.response != null) {
//         throw Exception(e.response?.data['message'] ?? 'Failed to change password');
//       }
//       throw Exception('Something went wrong');
//     }
//   }
// }