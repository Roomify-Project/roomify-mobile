abstract class PostsStates{}
class PostsInitialState extends PostsStates{}
class GetAllPostsLoadingState extends PostsStates{}

class GetAllPostsPostsSuccessState extends PostsStates{}
class GetAllPostsPostsErrorState extends PostsStates{
  final String message;

  GetAllPostsPostsErrorState({required this.message});
}

// /////       Get Missing       /////////////
// class GetMissingStudentLoadingState extends PostsStates{}
// class GetMissingStudentErrorState extends PostsStates{
//   final String error;
//   GetMissingStudentErrorState(this.error);
// }
// class GetMissingStudentSuccessState extends PostsStates{}
