import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/constans.dart';
import '../../../../core/helpers/shared_pref_helper.dart';
import '../../../../core/networking/dio_factory.dart';
import '../../data/models/login_request_body.dart';
import '../../data/models/login_response.dart';
import '../../data/repos/login_repo.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  final LoginRepo _loginRepo;

  LoginCubit(this._loginRepo) : super(LoginInitialState());
  static LoginCubit get(context) => BlocProvider.of<LoginCubit>(context);

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  LoginResponse? loginResponse;

  void login() async {
    emit(LoginLoadingState());
    final response = await _loginRepo.login(LoginRequestBody(
        email: emailController.text, password: passwordController.text));
    response.fold(
      (left) {
        emit(LoginLoadingErrorState(message: left.apiErrorModel.title??""));
      },
      (right) {
        saveUserData(right);
        emit(LoginSuccessState());
      },
    );
  }

  Future<void> saveUserToken(String token) async {
    await SharedPrefHelper.setData(SharedPrefKey.token, token);
    DioFactory.setTokenIntoHeaderAfterLogin(token);
  }
  Future<void> saveUserData(LoginResponse loginResponse) async {
    await SharedPrefHelper.setData("userId", loginResponse.userId);
    saveUserToken(loginResponse.token);
  }
}
