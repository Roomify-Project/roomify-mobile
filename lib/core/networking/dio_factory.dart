import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:rommify_app/core/helpers/constans.dart';
import '../helpers/shared_pref_helper.dart';
import 'api_networking.dart';

class DioFactory {
  DioFactory._();

  static Dio? dio;

  static Dio getDio() {
    Duration timeOut = const Duration(seconds: 60);

    if (dio == null) {
      dio = Dio();
      dio!
        ..options.baseUrl = ApiConstants.apiBaseUrl
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;
      addDioHeaders();
      return dio!;
    } else {
      return dio!;
    }
  }

  static void addDioHeaders() async {
    dio?.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${SharedPrefHelper.getString(SharedPrefKey.token)}',
    };
    addDioInterceptor();
  }

  static void setTokenIntoHeaderAfterLogin(String token) {
    dio?.options.headers = {
      'Authorization': 'Bearer $token',
    };
  }

  static void addDioInterceptor() {
    dio?.interceptors.addAll([
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          if (error.response?.statusCode == 401 || error.response?.statusCode == 403) {
            await _handleUnauthorized();
          }
          else{
            print("errrorr ${error.response?.statusCode}");
          }
          return handler.next(error);
        },
      ),
    ]);
  }

  static Future<void> _handleUnauthorized() async {
    // امسح التوكن أو اي بيانات محفوظة
    await SharedPrefHelper.clearData();

    // روح على صفحة اللوجين
    print("logggggg out");
  }

}