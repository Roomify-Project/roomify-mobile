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


// /////       Get Missing       /////////////
// class GetMissingStudentLoadingState extends PostsStates{}
// class GetMissingStudentErrorState extends PostsStates{
//   final String error;
//   GetMissingStudentErrorState(this.error);
// }
// class GetMissingStudentSuccessState extends PostsStates{}
