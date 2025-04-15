abstract class ForgetPasswordStates {}

class ForgetPasswordInitialState extends ForgetPasswordStates {}
class ForgetPasswordLoadingState extends ForgetPasswordStates {}
class ForgetPasswordSuccessState extends ForgetPasswordStates {}
class ForgetPasswordLoadingErrorState extends ForgetPasswordStates {
  final String message;
  ForgetPasswordLoadingErrorState({required this.message});
}

class OtpVerificationInitialState extends ForgetPasswordStates {}
class OtpVerificationLoadingState extends ForgetPasswordStates {}
class OtpVerificationSuccessState extends ForgetPasswordStates {}
class OtpVerificationErrorState extends ForgetPasswordStates {
  final String message;
  OtpVerificationErrorState({required this.message});
}

class ResetPasswordInitialState extends ForgetPasswordStates {}
class ResetPasswordLoadingState extends ForgetPasswordStates {}
class ResetPasswordSuccessState extends ForgetPasswordStates {}
class ResetPasswordErrorState extends ForgetPasswordStates {
  final String message;
  ResetPasswordErrorState({required this.message});
}