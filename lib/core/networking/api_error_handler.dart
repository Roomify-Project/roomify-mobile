import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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
  static const int API_LOGIC_ERROR = 422; // API, logic error

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
  static const String NO_CONTENT = ApiErrors.noContent; // success with no data (no content)
  static const String BAD_REQUEST = ApiErrors.badRequestError; // failure, API rejected request
  static const String UNAUTORISED = ApiErrors.unauthorizedError; // failure, user is not authorised
  static const String FORBIDDEN = ApiErrors.forbiddenError; //  failure, API rejected request
  static const String INTERNAL_SERVER_ERROR = ApiErrors.internalServerError; // failure, crash in server side
  static const String NOT_FOUND = ApiErrors.notFoundError; // failure, crash in server side

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
      print("diooooo");
      apiErrorModel = _handleError(error);
      if(apiErrorModel.status==401){
      }
    } else {
      print("not diooooo");
      apiErrorModel = DataSource.DEFAULT.getFailure();
    }
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
      return _handleUnknownError(error);
    case DioExceptionType.cancel:
      return DataSource.CANCEL.getFailure();
    case DioExceptionType.connectionError:
      return DataSource.DEFAULT.getFailure();
    case DioExceptionType.badCertificate:
      return DataSource.DEFAULT.getFailure();
    case DioExceptionType.badResponse:
      print("baddd responseeee");
      return _handleUnknownError(error);
  }
}

ApiErrorModel _handleUnknownError(DioException error) {
  // Handle unknown errors and extract messages if available
  String message = "An unexpected error occurred.";

  if (error.response != null && error.response?.data != null) {
    final data = error.response?.data;

    // Check if data is a Map before accessing keys
    if (data is Map) {
      // Handle different error response structures
      if (data.containsKey('errors')) {
        dynamic errors = data['errors'];
        
        // Check if errors is a Map
        if (errors is Map) {
          // Try different ways to extract error message
          if (errors.containsKey('Description') && 
              errors['Description'] is List && 
              errors['Description'].isNotEmpty) {
            message = errors['Description'][0];
          } else if (errors.containsKey('message')) {
            message = errors['message'];
          }
        } 
        // Check if errors is a List
        else if (errors is List && errors.isNotEmpty) {
          message = errors[0].toString();
        }
      }
      // Fallback to 'message' key if 'errors' not found
      else if (data.containsKey('message')) {
        message = data['message'].toString();
      }
    }
  }

  // If no specific error message found, use a default
  if (message == "An unexpected error occurred.") {
    message = error.response?.statusMessage ?? 
              "Unable to reach the server, please try again later.";
  }

  return ApiErrorModel(
    status: error.response?.statusCode ?? ResponseCode.DEFAULT, 
    title: message,
  );
}

ApiErrorModel _handleBadResponse(DioException error) {
  if (error.response != null) {
    var errorData = error.response?.data;
    if (errorData is Map<String, dynamic>) {
      String message = errorData['message'] ?? 'Server error occurred';
      return ApiErrorModel(
        status: error.response?.statusCode ?? ResponseCode.BAD_REQUEST,
        title: message,
      );
    }
  }
  return DataSource.BAD_REQUEST.getFailure();
}

// Example of ApiErrorModel and ApiErrors classes:
class ApiErrorModel {
  final int status;
  final String title;

  ApiErrorModel({required this.status, required this.title});
}

class ApiErrors {
  static const String noContent = "No content available";
  static const String badRequestError = "Bad request, please check the data.";
  static const String unauthorizedError = "Unauthorized, please log in.";
  static const String forbiddenError = "Forbidden access.";
  static const String internalServerError = "Internal server error.";
  static const String notFoundError = "Resource not found.";
  static const String timeoutError = "Connection timed out.";
  static const String cacheError = "Cache error.";
  static const String noInternetError = "No internet connection.";
  static const String defaultError = "An error occurred, please try again.";
}

class ApiInternalStatus {
  static const int SUCCESS = 0;
  static const int FAILURE = 1;
}