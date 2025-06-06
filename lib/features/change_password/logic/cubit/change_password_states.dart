abstract class ChangePasswordStates {}

class ChangePasswordInitialState extends ChangePasswordStates {}

class ChangePasswordLoadingState extends ChangePasswordStates {}

class ChangePasswordSuccessState extends ChangePasswordStates {
  final String message;
  ChangePasswordSuccessState({required this.message});
}

class ChangePasswordErrorState extends ChangePasswordStates {
  final String message;
  ChangePasswordErrorState({required this.message});
}