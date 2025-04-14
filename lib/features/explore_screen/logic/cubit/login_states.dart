import '../../data/models/add_post_nodel.dart';

abstract class PostsStates{}
class PostsInitialState extends PostsStates{}
class GetAllPostsLoadingState extends PostsStates{}
////get all posts
class GetAllPostsSuccessState extends PostsStates{}
class GetAllPostsErrorState extends PostsStates{
  final String message;

  GetAllPostsErrorState({required this.message});
}

////get user posts
class GetUsePostsLoadingState extends PostsStates{}

class GetUserPostsSuccessState extends PostsStates{}
class GetUserPostsErrorState extends PostsStates{
  final String message;

  GetUserPostsErrorState({required this.message});
}

//// get post
class GetPostLoadingState extends PostsStates{}
class  GetPostSuccessState extends PostsStates{}
class GetPostErrorState extends PostsStates{
  final String message;

  GetPostErrorState({required this.message});
}

//// add post
class AddPostLoadingState extends PostsStates{}
class  AddPostSuccessState extends PostsStates{
  final AddPostResponse addPostResponse;
  AddPostSuccessState(this.addPostResponse);
}
class AddPostErrorState extends PostsStates{
  final String message;

  AddPostErrorState({required this.message});
}
/// upload image
class UploadImageStata extends PostsStates{}

