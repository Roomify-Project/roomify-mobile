// import 'package:christy/core/helpers/constans.dart';
// import 'package:christy/core/helpers/shared_pref_helper.dart';
// import 'package:christy/features/login/data/models/login_request_body.dart';
// import 'package:christy/features/login/data/repos/login_repo.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../core/networking/dio_factory.dart';
// import 'login_states.dart';
//
// class LoginCubit extends Cubit<LoginState> {
//   final LoginRepo _loginRepo;
//
//   LoginCubit(this._loginRepo) : super(const LoginState.initial());
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//
//   void login() async {
//     emit(const LoginState.loading());
//     final response = await _loginRepo.login(LoginRequestBody(
//         email: emailController.text, password: passwordController.text));
//     response.when(success: (loginResponse)  async {
//        // SharedPrefHelper.setData(SharedPrefKey.token,loginResponse.token ??'');
//       await saveUserToken(loginResponse.token ?? '');
//       emit(LoginState.success(loginResponse));
//     }, failure: (error) {
//       emit(LoginState.error(error: error.apiErrorModel.title??''));
//     });
//   }
//   Future<void> saveUserToken(String token) async {
//     await SharedPrefHelper.setData(SharedPrefKey.token,token);
//     DioFactory.setTokenIntoHeaderAfterLogin(token);
//   }
// }
