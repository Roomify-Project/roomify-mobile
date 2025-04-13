import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/get_posts_response.dart';
import '../../data/repos/posts_repo.dart';
import 'login_states.dart';

class PostsCubit extends Cubit<PostsStates> {
  final PostsRepo _postsRepo;
  PostsCubit(this._postsRepo) : super(PostsInitialState());
  static PostsCubit get(context) => BlocProvider.of<PostsCubit>(context);
  GetPostsResponse ?getPostsResponse;
  GetPostsResponse ?getAllPostsResponse;

  void getAllPosts() async {
    emit(GetAllPostsLoadingState());
    final response = await _postsRepo.getAllPosts();
    response.fold(
      (left) {
        emit(GetAllPostsErrorState(message: left.apiErrorModel.title??""));
      },
      (right) {
        getAllPostsResponse=right;
        emit(GetAllPostsSuccessState());
      },
    );
  }

  void getUserPosts({required String id}) async {
    emit(GetUsePostsLoadingState());
    final response = await _postsRepo.getUserPosts(id: id);
    response.fold(
          (left) {
        emit(GetUserPostsErrorState(message: left.apiErrorModel.title??""));
      },
          (right) {
            print("sucessssss ${getAllPostsResponse!.posts}");
            getPostsResponse=right;

            emit(GetUserPostsSuccessState());
      },
    );
  }


}
