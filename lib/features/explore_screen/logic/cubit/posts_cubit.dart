import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repos/posts_repo.dart';
import 'login_states.dart';

class PostsCubit extends Cubit<PostsStates> {
  final PostsRepo _postsRepo;

  PostsCubit(this._postsRepo) : super(PostsInitialState());
  static PostsCubit get(context) => BlocProvider.of<PostsCubit>(context);

  void getAllPosts() async {
    emit(GetAllPostsLoadingState());
    final response = await _postsRepo.getAllPosts();
    response.fold(
      (left) {
        emit(GetAllPostsPostsErrorState(message: left.apiErrorModel.title??""));
      },
      (right) {
        emit(GetAllPostsPostsSuccessState());
      },
    );
  }


}
