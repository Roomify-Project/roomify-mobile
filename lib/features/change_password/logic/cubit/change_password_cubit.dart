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