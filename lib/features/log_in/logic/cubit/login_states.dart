abstract class LoginStates{}
class LoginInitialState extends LoginStates{}
class LoginLoadingState extends LoginStates{}

class LoginSuccessState extends LoginStates{}
class LoginLoadingErrorState extends LoginStates{
  final String message;

  LoginLoadingErrorState({required this.message});
}

// /////       Get Missing       /////////////
// class GetMissingStudentLoadingState extends LoginStates{}
// class GetMissingStudentErrorState extends LoginStates{
//   final String error;
//   GetMissingStudentErrorState(this.error);
// }
// class GetMissingStudentSuccessState extends LoginStates{}
