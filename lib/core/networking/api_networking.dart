class ApiConstants {
  // static const String singularServerUrl = "https://syncord.koyeb.app/chat";
  static const String apiBaseUrl = "http://roomify0.runasp.net";
  static const String signalRUrl = "http://roomify0.runasp.net/Chat";

  static const String loginUrl = '/api/Auth/login';
  static const String getAllPostsUrl = '/api/PortfolioPost/';
  static String getUserPostsUrl({required String id}){
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
  static const String signUpUrl = '/api/Auth/register';
  static const String verifyOtpUrl = '/api/Auth/confirm-email';
  static const String forgetPasswordUrl = '/api/Auth/forget-password';
  static const String resetPasswordUrl = '/api/Auth/reset-password';
  static  String addFollowUrl({required String followId}){
   return '/api/follow/$followId';
}
  static  String deleteFollowUrl({required String followId}){
    return '/api/follow/$followId';
  }


  static  String getIsFollowingUrl({required String followId}){
    return '/api/follow/is-following/$followId';
  }
  static  String profileId({required String profileId}){
    return '/api/users/$profileId';
  }
  static  String getProfileData({required String profileId}){
    return '/api/users/$profileId';
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