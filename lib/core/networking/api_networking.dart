class ApiConstants {
  static const String apiBaseUrl = "http://roomify.runasp.net";
  static const String loginModel = '/api/Auth/login';
  static const String signUpModel = '/api/Auth/register';
  static const String verifyOtpModel = '/api/Auth/confirm-email';
  static const String forgetPasswordModel = '/api/Auth/forget-password';
  static const String resetPasswordModel = '/api/Auth/reset-password';
}

class ApiErrors {
  static const String badRequestError = "Something went wrong. Please check your information and try again.";
  static const String noContent = "No content available.";
  static const String forbiddenError = "You don't have permission to access this resource.";
  static const String unauthorizedError = "You need to login to access this feature.";
  static const String notFoundError = "The requested resource was not found.";
  static const String conflictError = "A conflict occurred with your request.";
  static const String internalServerError = "Server error. Please try again later.";
  static const String unknownError = "Unknown error occurred.";
  static const String timeoutError = "Connection timeout. Please check your internet and try again.";
  static const String defaultError = "Something went wrong. Please try again later.";
  static const String cacheError = "Cache error occurred.";
  static const String noInternetError = "No internet connection. Please check your network and try again.";
  static const String loadingMessage = "Loading...";
  static const String retryAgainMessage = "Try again";
  static const String ok = "Ok";
  
  // Custom errors for form validation
  static const String invalidUsername = "This username is already taken. Please try another one.";
  static const String invalidEmail = "This email is already registered. Please use another email or login.";
  static const String invalidPassword = "Password must have at least 8 characters, including one uppercase letter, one lowercase letter, one number, and one special character.";
  static const String invalidOtp = "Invalid verification code. Please try again.";
}
