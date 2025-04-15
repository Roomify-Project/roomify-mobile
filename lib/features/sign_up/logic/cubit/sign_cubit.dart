import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/sign_request_body.dart';
import '../../data/repos/sign_repo.dart';
import 'sign_states.dart';

class SignUpCubit extends Cubit<SignUpStates> {
  final SignUpRepo _signUpRepo;

  SignUpCubit(this._signUpRepo) : super(SignUpInitialState());

  static SignUpCubit get(context) => BlocProvider.of<SignUpCubit>(context);

  TextEditingController fullNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? registeredEmail;
  final formKey = GlobalKey<FormState>();

  void signUp() async {
    emit(SignUpLoadingState());
    final response = await _signUpRepo.signUp(SignUpRequestBody(
        fullName: fullNameController.text,
        userName: userNameController.text,
        email: emailController.text,
        password: passwordController.text));

    response.fold(
      (left) {
        String errorMessage = left.apiErrorModel.title ?? "An error occurred";
     
        if (errorMessage.toLowerCase().contains('username')) {
          errorMessage = "This username is already taken. Please try another one.";
        } else if (errorMessage.toLowerCase().contains('email')) {
          errorMessage = "This email is already registered. Please use another email or login.";
        }
        
        emit(SignUpLoadingErrorState(message: errorMessage));
      },
      (right) {
        registeredEmail = emailController.text;
        emit(SignUpSuccessState());
      },
    );
  }

  void verifyOtp(String otp) async {
    if (registeredEmail == null) {
      emit(OtpLoadingErrorState(
          message: "Email not found. Please register first."));
      return;
    }

    emit(OtpLoadingState());
    try {
      final response = await _signUpRepo
          .verifyOtp(OtpRequestBody(email: registeredEmail!, otpCode: otp));

      response.fold(
        (left) {
          String errorMessage = left.apiErrorModel.title ?? "An error occurred";
      
          if (errorMessage.toLowerCase().contains('bad request') || 
              errorMessage.toLowerCase().contains('invalid')) {
            errorMessage = "Invalid verification code. Please check and try again.";
          }
          
          emit(OtpLoadingErrorState(message: errorMessage));
        },
        (right) {
 
          if (right.message.isEmpty ||
              right.message.contains("confirmed") ||
              right.message.contains("success") ||
              right.message.contains("verified")) {
            emit(OtpSuccessState());
          } else {
            emit(OtpLoadingErrorState(message: "Invalid verification code. Please try again."));
          }
        },
      );
    } catch (e) {
      emit(OtpLoadingErrorState(message: "Verification failed. Please try again."));
    }
  }
}