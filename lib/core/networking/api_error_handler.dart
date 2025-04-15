import 'package:dio/dio.dart';
import 'api_error_model.dart';
import 'api_networking.dart';

enum DataSource {
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECIEVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  DEFAULT
}

class ResponseCode {
  static const int SUCCESS = 200; // success with data
  static const int NO_CONTENT = 201; // success with no data (no content)
  static const int BAD_REQUEST = 400; // failure, API rejected request
  static const int UNAUTORISED = 401; // failure, user is not authorised
  static const int FORBIDDEN = 403; //  failure, API rejected request
  static const int INTERNAL_SERVER_ERROR = 500; // failure, crash in server side
  static const int NOT_FOUND = 404; // failure, not found
  static const int API_LOGIC_ERROR = 422; // API , lOGIC ERROR

  // local status status
  static const int CONNECT_TIMEOUT = -1;
  static const int CANCEL = -2;
  static const int RECIEVE_TIMEOUT = -3;
  static const int SEND_TIMEOUT = -4;
  static const int CACHE_ERROR = -5;
  static const int NO_INTERNET_CONNECTION = -6;
  static const int DEFAULT = -7;
}

class ResponseMessage {
  static const String NO_CONTENT =
      ApiErrors.noContent; // success with no data (no content)
  static const String BAD_REQUEST =
      ApiErrors.badRequestError; // failure, API rejected request
  static const String UNAUTORISED =
      ApiErrors.unauthorizedError; // failure, user is not authorised
  static const String FORBIDDEN =
      ApiErrors.forbiddenError; //  failure, API rejected request
  static const String INTERNAL_SERVER_ERROR =
      ApiErrors.internalServerError; // failure, crash in server side
  static const String NOT_FOUND =
      ApiErrors.notFoundError; // failure, crash in server side

  // local status status
  static String CONNECT_TIMEOUT = ApiErrors.timeoutError;
  static String CANCEL = ApiErrors.defaultError;
  static String RECIEVE_TIMEOUT = ApiErrors.timeoutError;
  static String SEND_TIMEOUT = ApiErrors.timeoutError;
  static String CACHE_ERROR = ApiErrors.cacheError;
  static String NO_INTERNET_CONNECTION = ApiErrors.noInternetError;
  static String DEFAULT = ApiErrors.defaultError;
}

extension DataSourceExtension on DataSource {
  ApiErrorModel getFailure() {
    switch (this) {
      case DataSource.NO_CONTENT:
        return ApiErrorModel(
            status: ResponseCode.NO_CONTENT, title: ResponseMessage.NO_CONTENT);
      case DataSource.BAD_REQUEST:
        return ApiErrorModel(
            status: ResponseCode.BAD_REQUEST,
            title: ResponseMessage.BAD_REQUEST);
      case DataSource.FORBIDDEN:
        return ApiErrorModel(
            status: ResponseCode.FORBIDDEN, title: ResponseMessage.FORBIDDEN);
      case DataSource.UNAUTORISED:
        return ApiErrorModel(
            status: ResponseCode.UNAUTORISED,
            title: ResponseMessage.UNAUTORISED);
      case DataSource.NOT_FOUND:
        return ApiErrorModel(
            status: ResponseCode.NOT_FOUND, title: ResponseMessage.NOT_FOUND);
      case DataSource.INTERNAL_SERVER_ERROR:
        return ApiErrorModel(
            status: ResponseCode.INTERNAL_SERVER_ERROR,
            title: ResponseMessage.INTERNAL_SERVER_ERROR);
      case DataSource.CONNECT_TIMEOUT:
        return ApiErrorModel(
            status: ResponseCode.CONNECT_TIMEOUT,
            title: ResponseMessage.CONNECT_TIMEOUT);
      case DataSource.CANCEL:
        return ApiErrorModel(
            status: ResponseCode.CANCEL, title: ResponseMessage.CANCEL);
      case DataSource.RECIEVE_TIMEOUT:
        return ApiErrorModel(
            status: ResponseCode.RECIEVE_TIMEOUT,
            title: ResponseMessage.RECIEVE_TIMEOUT);
      case DataSource.SEND_TIMEOUT:
        return ApiErrorModel(
            status: ResponseCode.SEND_TIMEOUT,
            title: ResponseMessage.SEND_TIMEOUT);
      case DataSource.CACHE_ERROR:
        return ApiErrorModel(
            status: ResponseCode.CACHE_ERROR,
            title: ResponseMessage.CACHE_ERROR);
      case DataSource.NO_INTERNET_CONNECTION:
        return ApiErrorModel(
            status: ResponseCode.NO_INTERNET_CONNECTION,
            title: ResponseMessage.NO_INTERNET_CONNECTION);
      case DataSource.DEFAULT:
        return ApiErrorModel(
            status: ResponseCode.DEFAULT, title: ResponseMessage.DEFAULT);
    }
  }
}

class ErrorHandler implements Exception {
  late ApiErrorModel apiErrorModel;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      if(error.type == DioExceptionType.badResponse || error.type == DioExceptionType.unknown) {
        if (error.response != null &&
            error.response?.statusCode != null &&
            error.response?.statusMessage != null) {
          // Check if there's a specific error message in the response
          if (error.response?.data != null && error.response?.data is Map) {
            final responseData = error.response?.data as Map<String, dynamic>;
            
            // Extract meaningful error messages for common issues
            if (responseData.containsKey('message')) {
              String errorMessage = responseData['message'];
              
              // Check for common error patterns and provide better messages
              if (errorMessage.toLowerCase().contains('username') && 
                  errorMessage.toLowerCase().contains('already')) {
                apiErrorModel = ApiErrorModel(
                  status: error.response?.statusCode,
                  title: "Username is already taken. Please try another username.",
                );
                return;
              } else if (errorMessage.toLowerCase().contains('email') && 
                        errorMessage.toLowerCase().contains('already')) {
                apiErrorModel = ApiErrorModel(
                  status: error.response?.statusCode,
                  title: "Email is already registered. Please use another email or login.",
                );
                return;
              } else if (errorMessage.toLowerCase().contains('otp') && 
                        (errorMessage.toLowerCase().contains('invalid') || 
                         errorMessage.toLowerCase().contains('incorrect'))) {
                apiErrorModel = ApiErrorModel(
                  status: error.response?.statusCode,
                  title: "Invalid verification code. Please try again.",
                );
                return;
              } else {
                apiErrorModel = ApiErrorModel(
                  status: error.response?.statusCode,
                  title: errorMessage,
                );
                return;
              }
            } else if (responseData.containsKey('error')) {
              apiErrorModel = ApiErrorModel(
                status: error.response?.statusCode,
                title: _getImprovedErrorMessage(responseData['error'], error.response?.statusCode),
              );
              return;
            }
          }
          
          // If no specific message found, provide a better message based on status code
          apiErrorModel = ApiErrorModel(
            status: error.response?.statusCode,
            title: _getImprovedErrorMessage(error.response?.statusMessage, error.response?.statusCode),
          );
          return;
        }
      }
      // dio error so its an error from response of the API or from dio itself
      apiErrorModel = _handleError(error);
    } else {
      // default error
      apiErrorModel = DataSource.DEFAULT.getFailure();
    }
  }
  
  String _getImprovedErrorMessage(String? originalMessage, int? statusCode) {
    if (statusCode == 400) {
      if (originalMessage?.toLowerCase().contains('username') ?? false) {
        return "Username is already taken. Please try another username.";
      } else if (originalMessage?.toLowerCase().contains('email') ?? false) {
        return "Email is already registered. Please use another email.";
      } else if (originalMessage?.toLowerCase().contains('otp') ?? false) {
        return "Invalid verification code. Please try again.";
      } else if (originalMessage?.toLowerCase().contains('password') ?? false) {
        return "Password doesn't meet the security requirements.";
      } else if (originalMessage?.toLowerCase().contains('bad request') ?? false) {
        return "Invalid verification code. Please check and try again.";
      }
    }
    return originalMessage ?? "An error occurred. Please try again.";
  }
}

ApiErrorModel _handleError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return DataSource.CONNECT_TIMEOUT.getFailure();
    case DioExceptionType.sendTimeout:
      return DataSource.SEND_TIMEOUT.getFailure();
    case DioExceptionType.receiveTimeout:
      return DataSource.RECIEVE_TIMEOUT.getFailure();
    case DioExceptionType.unknown:
      if (error.message?.contains('SocketException') ?? false) {
        return DataSource.NO_INTERNET_CONNECTION.getFailure();
      }
      return DataSource.DEFAULT.getFailure();
    case DioExceptionType.cancel:
      return DataSource.CANCEL.getFailure();
    case DioExceptionType.connectionError:
      return DataSource.NO_INTERNET_CONNECTION.getFailure();
    case DioExceptionType.badCertificate:
      return DataSource.DEFAULT.getFailure();
    case DioExceptionType.badResponse:
      switch (error.response?.statusCode) {
        case ResponseCode.BAD_REQUEST:
          // Check for OTP error specifically
          if (error.response?.data != null && 
              error.response?.data is Map &&
              (error.response?.data as Map).containsKey('message')) {
            String message = (error.response?.data as Map)['message'];
            if (message.toLowerCase().contains('otp')) {
              return ApiErrorModel(
                status: ResponseCode.BAD_REQUEST,
                title: "Invalid verification code. Please try again.",
              );
            }
          }
          return DataSource.BAD_REQUEST.getFailure();
        case ResponseCode.FORBIDDEN:
          return DataSource.FORBIDDEN.getFailure();
        case ResponseCode.UNAUTORISED:
          return DataSource.UNAUTORISED.getFailure();
        case ResponseCode.NOT_FOUND:
          return DataSource.NOT_FOUND.getFailure();
        case ResponseCode.INTERNAL_SERVER_ERROR:
          return DataSource.INTERNAL_SERVER_ERROR.getFailure();
        default:
          return DataSource.DEFAULT.getFailure();
      }
  }
}

class ApiInternalStatus {
  static const int SUCCESS = 0;
  static const int FAILURE = 1;
}