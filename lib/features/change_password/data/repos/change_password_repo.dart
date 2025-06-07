import 'package:either_dart/either.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../apis/change_password_api_service.dart';
import '../models/change_password_body.dart';

class ChangePasswordRepo {
  final ChangePasswordApiService _apiService;

  ChangePasswordRepo(this._apiService);

  Future<Either<ErrorHandler, String>> changePassword(
      ChangePasswordBody body) async {
    try {
      final response = await _apiService.changePassword(body);
      return Right(response.data);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}