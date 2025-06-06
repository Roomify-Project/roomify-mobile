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
  static String sendMessage="/api/Chat/sendMessage";
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
  static const String updateProfile='/api/Users/update-profile';
  static  String getProfileData({required String profileId}){
    return '/api/users/$profileId';
  }
  static  String getMessage({required String receiverId}){
    return '/api/Chat/getMessages/$receiverId';
  }

  static  String getFollowCount({required String followId}){
    return '/api/follow/counts/$followId';
  }

  static String getCommentPost({required String postId}){
    return "/api/Comments/post/$postId";
  }
  static String addComment="/api/Comments/";
  static String updateComment({required String commentId}){
    return "/api/Comments/$commentId";
  }
  static String deleteComment({required String commentId}){
    return "/api/Comments/$commentId";
  }

  static String generate="/api/RoomImage/generate-design";
  static String generateMore="/api/RoomImage/generate-more";
  static String download="/api/RoomImage/download";
  static String saveDesign="/api/RoomImage/save-design";
  static  String getHistory({required String userId}){
    return '/api/RoomImage/history/$userId';
  }
  static  String getSavedDesign({required String userId}){
    return '/api/RoomImage/saved-designs/$userId';
  }
  static  String getFollowersList({required String userId}){
    return '/api/follow/followers/$userId';
  }
  static  String getFollowingList({required String userId}){
    return '/api/follow/following/$userId';
  }
  static const String getAllNotification='/api/notifications';
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