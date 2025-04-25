class ApiConstants {
  // static const String singularServerUrl = "https://syncord.koyeb.app/chat";
  static const String apiBaseUrl = "http://roomify0.runasp.net";
  static const String signalRUrl = "http://roomify0.runasp.net/Chat";

  static const String loginModel = '/api/Auth/login';
  static const String getAllPostsModel = '/api/PortfolioPost/';
  static String getUserPostsModel({required String id}){
    return "/api/PortfolioPost/by-user/$id";
  }
  static String getPost({required String id}){
    return "/api/PortfolioPost/$id";
  }
  static String addPost({required String userId}){
    return "/api/PortfolioPost/upload/$userId";
  }
  static String deletePost({required String postId}){
      return "/api/PortfolioPost/$postId";
  }
  static const String signUpModel = '/api/Auth/register';
  static const String verifyOtpModel = '/api/Auth/confirm-email';
  static const String forgetPasswordModel = '/api/Auth/forget-password';
  static const String resetPasswordModel = '/api/Auth/reset-password';
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