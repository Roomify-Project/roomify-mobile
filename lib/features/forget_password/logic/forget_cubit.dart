// forget_cubit.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/forget_repo.dart';
import '../data/models/forget_request_body.dart';
import 'forget_states.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordStates> {
  final ForgetPasswordRepo _forgetPasswordRepo;

  ForgetPasswordCubit(this._forgetPasswordRepo) : super(ForgetPasswordInitialState());

  static ForgetPasswordCubit get(context) => BlocProvider.of<ForgetPasswordCubit>(context);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? storedEmail;
  String? storedOtp;

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }

  void sendOtp() async {
    emit(ForgetPasswordLoadingState());

    final email = emailController.text.trim();

    try {
      final response = await _forgetPasswordRepo.sendOtp(
        ForgetPasswordRequestBody(email: email),
      );

      response.fold(
        (left) {
          emit(ForgetPasswordLoadingErrorState(
              message: left.apiErrorModel.title ?? "An error occurred"));
        },
        (right) {
          storedEmail = email;
          emit(ForgetPasswordSuccessState());
        },
      );
    } catch (e) {
      emit(ForgetPasswordLoadingErrorState(message: "An unexpected error occurred"));
    }
  }

  void verifyOtp(String otp) async {
    if (storedEmail == null) {
      emit(OtpVerificationErrorState(
          message: "Email not found. Please try again."));
      return;
    }


    emit(OtpVerificationLoadingState());

    storedOtp = otp;

    emit(OtpVerificationSuccessState());
  }

  void resetPassword() async {
    if (storedEmail == null || storedOtp == null) {
      emit(ResetPasswordErrorState(
          message: "Missing information. Please start over."));
      return;
    }

    emit(ResetPasswordLoadingState());

    try {
      final response = await _forgetPasswordRepo.resetPassword(
        ResetPasswordRequestBody(
          email: storedEmail!,
          otpCode: storedOtp!,
          newPassword: passwordController.text,
        ),
      );

      response.fold(
        (left) {
          emit(ResetPasswordErrorState(
              message: left.apiErrorModel.title ?? "Failed to reset password"));
        },
        (right) {
          emit(ResetPasswordSuccessState());
          storedEmail = null;
          storedOtp = null;
          passwordController.clear();
          emailController.clear();
        },
      );
    } catch (e) {
      emit(ResetPasswordErrorState(message: "Unexpected error occurred"));
    }
  }
}
