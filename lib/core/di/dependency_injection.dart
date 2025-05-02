
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rommify_app/features/chat/logic/cubit/chat_cubit.dart';
import 'package:rommify_app/features/explore_screen/data/apis/posts_api_service.dart';
import 'package:rommify_app/features/explore_screen/data/repos/posts_repo.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/posts_cubit.dart';
import 'package:rommify_app/features/profile/data/apis/profile_api_service.dart';
import 'package:rommify_app/features/profile/data/repos/profile_repo.dart';
import 'package:rommify_app/features/profile/logic/cubit/profile_cubit.dart';

import '../../features/chat/data/apis/chat_api_service.dart';
import '../../features/chat/data/repos/chat_repo.dart';
import '../../features/forget_password/data/apis/forget_api_service.dart';
import '../../features/forget_password/data/repo/forget_repo.dart';
import '../../features/forget_password/logic/forget_cubit.dart';
import '../../features/log_in/data/apis/login_api_service.dart';
import '../../features/log_in/data/repos/login_repo.dart';
import '../../features/log_in/logic/cubit/login_cubit.dart';
import '../../features/sign_up/data/apis/sign_api_service.dart';
import '../../features/sign_up/data/repos/sign_repo.dart';
import '../../features/sign_up/logic/cubit/sign_cubit.dart';
import '../helpers/shared_pref_helper.dart';
import '../networking/dio_factory.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Dio & ApiService
  Dio dio = DioFactory.getDio();
  // login

  getIt.registerLazySingleton<LoginApiService>(() => LoginApiService(dio: dio));
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));

  //// posts
  getIt.registerLazySingleton<PostsApiService>(() => PostsApiService(dio: dio));
  getIt.registerLazySingleton<PostsRepo>(() => PostsRepo(getIt()));
  getIt.registerFactory<PostsCubit>(() => PostsCubit(getIt()));
  //
  //register
  getIt.registerLazySingleton<SignUpApiService>(() => SignUpApiService(dio: dio));
  getIt.registerLazySingleton<SignUpRepo>(() => SignUpRepo(getIt()));
  getIt.registerFactory<SignUpCubit>(() => SignUpCubit(getIt()));

//forget password
  getIt.registerLazySingleton<ForgetPasswordApiService>(() => ForgetPasswordApiService(dio: dio));
  getIt.registerLazySingleton<ForgetPasswordRepo>(() => ForgetPasswordRepo(getIt()));
  getIt.registerFactory<ForgetPasswordCubit>(() => ForgetPasswordCubit(getIt()));


  //// profile/////
  getIt.registerLazySingleton<ProfileApiService>(() => ProfileApiService(dio: dio));
  getIt.registerLazySingleton<ProfileRepo>(() => ProfileRepo(getIt()));
  getIt.registerFactory<ProfileCubit>(() => ProfileCubit(getIt()));

  ///// chat
  getIt.registerLazySingleton<ChatApiService>(() => ChatApiService(dio: dio));
  getIt.registerLazySingleton<ChatRepo>(() => ChatRepo(getIt()));
  getIt.registerFactory<ChatCubit>(() => ChatCubit(getIt()));

  // //friend list
  // getIt.registerLazySingleton<GetFriendsApiService>(() => GetFriendsApiService(dio));
  // // getIt.registerLazySingleton<SignalRService>(() => SignalRService());
  //
  // getIt.registerLazySingleton<FriendListRepo>(() => FriendListRepo(getIt()));
  // getIt.registerLazySingleton<FriendListCubit>(() => FriendListCubit(getIt()));
  //
  // //search friend
  // getIt.registerLazySingleton<SearchFriendApiService>(() => SearchFriendApiService(dio));
  //
  // getIt.registerLazySingleton<SearchFriendRepo>(() => SearchFriendRepo(getIt()));
  // getIt.registerLazySingleton<SearchFriendCubit>(() => SearchFriendCubit(getIt()));
  //
  //
  // //Get Messages
  // getIt.registerLazySingleton<ChatApiService>(() => ChatApiService(dio));
  // getIt.registerLazySingleton<ChatRepo>(() => ChatRepo(getIt()));
  // getIt.registerLazySingleton<ChatCubit>(() => ChatCubit(getIt()));
  //
  // // get friends request
  // getIt.registerLazySingleton<GetFriendsRequestApiService>(() => GetFriendsRequestApiService(dio));
  // getIt.registerLazySingleton<GetFriendsRequestRepo>(() => GetFriendsRequestRepo(getIt()));
  // getIt.registerLazySingleton<GetFriendsRequestCubit>(() => GetFriendsRequestCubit(getIt()));
  //

}
