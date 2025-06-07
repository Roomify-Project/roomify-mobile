import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/change_password_body.dart';
import '../../data/repos/change_password_repo.dart';
import 'change_password_states.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordStates> {
  final ChangePasswordRepo _repo;

  ChangePasswordCubit(this._repo) : super(ChangePasswordInitialState());

  static ChangePasswordCubit get(context) => BlocProvider.of<ChangePasswordCubit>(context);

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  void changePassword() async {
    if (newPasswordController.text != confirmNewPasswordController.text) {
      emit(ChangePasswordErrorState(
          message: "New password and confirm password don't match"));
      return;
    }

    emit(ChangePasswordLoadingState());
    
    final response = await _repo.changePassword(
      ChangePasswordBody(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
        confirmNewPassword: confirmNewPasswordController.text,
      ),
    );

    response.fold(
      (left) => emit(ChangePasswordErrorState(message: left.apiErrorModel.title)),
      (right) {
        emit(ChangePasswordSuccessState(message: right));
        _clearControllers();
      },
    );
  }

  void _clearControllers() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmNewPasswordController.clear();
  }

  @override
  Future<void> close() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    return super.close();
  }
}