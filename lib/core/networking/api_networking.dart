class ApiConstants {
  static const String singularServerUrl = "https://syncord.koyeb.app/chat";
  static const String apiBaseUrl = "https://syncord.koyeb.app";
  static const String loginModel = '/User/login';
  static const String getFriendsListModel = '/User/dashboard';
  static const String searchFriend = '/FriendShip/Search';
  static const String addFriend = '/FriendShip/Send-request';
  static const String sendMessage = '/Chat';

  static const String getMessagePath = '/Chat/{number}'; // Placeholder for dynamic path

  static String getMessage(int number) => '/Chat/$number';
  static const String getFriendsRequest = '/User/requests'; // Placeholder for dynamic path
  static const String acceptFriendsRequest = '/FriendShip/accept-request'; // Placeholder for dynamic path
  static const String rejectedFriendsRequest = '/FriendShip/reject-request'; // Placeholder for dynamic path

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