// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rommify_app/features/change_password/data/models/change_password_request_body.dart';
// import 'package:rommify_app/features/change_password/logic/cubit/change_password_states.dart';

// import '../../data/repos/change_password_repo.dart';


// class ChangePasswordCubit extends Cubit<ChangePasswordState> {
//   final ChangePasswordRepo _repo;
//   final formKey = GlobalKey<FormState>();
  
//   final TextEditingController currentPasswordController = TextEditingController();
//   final TextEditingController newPasswordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();

//   ChangePasswordCubit(this._repo) : super(ChangePasswordInitial());

//   static ChangePasswordCubit get(context) => BlocProvider.of(context);

//   Future<void> changePassword() async {
//     if (!formKey.currentState!.validate()) return;

//     emit(ChangePasswordLoading());

//     try {
//       final request = ChangePasswordRequestModel(
//         currentPassword: currentPasswordController.text,
//         newPassword: newPasswordController.text,
//         confirmNewPassword: confirmPasswordController.text,
//       );

//       final response = await _repo.changePassword(request);
//       emit(ChangePasswordSuccess(response.message));
//       _clearControllers();
//     } catch (e) {
//       emit(ChangePasswordError(e.toString()));
//     }
//   }

//   void _clearControllers() {
//     currentPasswordController.clear();
//     newPasswordController.clear();
//     confirmPasswordController.clear();
//   }

//   @override
//   Future<void> close() {
//     currentPasswordController.dispose();
//     newPasswordController.dispose();
//     confirmPasswordController.dispose();
//     return super.close();
//   }
// }
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