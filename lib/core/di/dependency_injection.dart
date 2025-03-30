
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/log_in/data/apis/login_api_service.dart';
import '../../features/log_in/data/repos/login_repo.dart';
import '../../features/log_in/logic/cubit/login_cubit.dart';
import '../helpers/shared_pref_helper.dart';
import '../networking/dio_factory.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Dio & ApiService
  Dio dio = DioFactory.getDio();

  getIt.registerLazySingleton<LoginApiService>(() => LoginApiService(dio: dio));

  // login
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));

  //
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
