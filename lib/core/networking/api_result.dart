import 'api_error_handler.dart';

abstract class ApiResult<T> {
  factory ApiResult.success(T data) = Success<T>;

  factory ApiResult.failure(ErrorHandler errorHandler) = Failure<T>;
}

class Success<T> implements ApiResult<T> {
  final T data;
  Success(this.data);
}

class Failure<T> implements ApiResult<T> {
  final ErrorHandler errorHandler;

  Failure(this.errorHandler);
}