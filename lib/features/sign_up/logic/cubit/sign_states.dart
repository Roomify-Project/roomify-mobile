abstract class SignUpStates {}

class SignUpInitialState extends SignUpStates {}
class SignUpLoadingState extends SignUpStates {}
class SignUpSuccessState extends SignUpStates {}
class SignUpLoadingErrorState extends SignUpStates {
  final String message;
  SignUpLoadingErrorState({required this.message});
}

class OtpInitialState extends SignUpStates {}
class OtpLoadingState extends SignUpStates {}
class OtpSuccessState extends SignUpStates {}
class OtpLoadingErrorState extends SignUpStates {
  final String message;
  OtpLoadingErrorState({required this.message});
}
class SignUpRoleChangedState extends SignUpStates {}
