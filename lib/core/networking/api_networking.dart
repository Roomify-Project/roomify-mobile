class ApiConstants {
  // static const String singularServerUrl = "https://syncord.koyeb.app/chat";
  static const String apiBaseUrl = "http://roomify.runasp.net";
  static const String loginModel = '/api/Auth/login';
  static const String getAllPostsModel = '/api/PortfolioPost/';
  static String getUserPostsModel({required String id}){
    return "/api/PortfolioPost/by-user/$id";
  }


}



class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "There are error,please try later";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}