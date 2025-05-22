import 'package:rommify_app/features/explore_screen/data/models/get_omment_model.dart';

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


//get comment ////
class GetCommentLoadingState extends PostsStates{}
class  GetCommentSuccessState extends PostsStates{}
class GetCommentErrorState extends PostsStates{
  final String message;

  GetCommentErrorState({required this.message});
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


//// delete post
class DeletePostLoadingState extends PostsStates{}
class  DeletePostSuccessState extends PostsStates{
  final String message;
  DeletePostSuccessState(this.message);
}
class DeletePostErrorState extends PostsStates{
  final String message;

  DeletePostErrorState({required this.message});
}

//// add comment
class AddCommentLoadingState extends PostsStates{}
class  AddCommentSuccessState extends PostsStates{
  final CommentData commentData;
  AddCommentSuccessState(this.commentData);
}
class AddCommentErrorState extends PostsStates{
  final String message;

  AddCommentErrorState({required this.message});
}

/// upload image
class UploadImageStata extends PostsStates{}

class ChangeTimeState extends PostsStates{}
