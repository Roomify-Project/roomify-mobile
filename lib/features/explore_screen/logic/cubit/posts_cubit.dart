import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rommify_app/core/helpers/constans.dart';
import 'package:rommify_app/core/helpers/shared_pref_helper.dart';
import 'package:rommify_app/features/explore_screen/data/models/add_comment_body.dart';
import 'package:rommify_app/features/explore_screen/data/models/search_user_model.dart';

import '../../../create_room_screen/data/models/image_icon_state.dart';
import '../../../profile/data/models/get_all_chats_response.dart';
import '../../data/models/get_omment_model.dart';
import '../../data/models/get_post_model.dart';
import '../../data/models/get_posts_response.dart';
import '../../data/repos/posts_repo.dart';
import 'login_states.dart';

class PostsCubit extends Cubit<PostsStates> {
  final PostsRepo _postsRepo;

  PostsCubit(this._postsRepo) : super(PostsInitialState());

  static PostsCubit get(context) => BlocProvider.of<PostsCubit>(context);
  GetPostsResponse? getPostsResponse;
  GetPostsResponse? getAllPostsResponse;
  GetPostResponse? getPostResponse;
  GetCommentResponse? getCommentResponse;
  final commentController = TextEditingController();
  late TextEditingController updateCommentController;

  void getAllPosts() async {
    emit(GetAllPostsLoadingState());
    final response = await _postsRepo.getAllPosts();
    response.fold(
      (left) {
        print("leftttt ${left.apiErrorModel.title}");
        emit(GetAllPostsErrorState(message: left.apiErrorModel.title));
      },
      (right) {
        getAllPostsResponse = right;
        isExpandedListExploreScreen = List.generate(right.posts.length, (index) => false);

        emit(GetAllPostsSuccessState());
      },
    );
  }

  List<bool> isExpandedList = [];

  void getUserPosts({required String id}) async {
    emit(GetUsePostsLoadingState());
    final response = await _postsRepo.getUserPosts(id: id);
    response.fold(
      (left) {
        emit(GetUserPostsErrorState(message: left.apiErrorModel.title ?? ""));
      },
      (right) {
        isExpandedList = List.generate(right.posts.length, (index) => false);

        print("sucessssss ${getAllPostsResponse?.posts}");
        getPostsResponse = right;

        emit(GetUserPostsSuccessState());
      },
    );
  }
  List<bool> isExpandedListExploreScreen = [];


  void getPost({required String postId}) async {
    emit(GetPostLoadingState());
    final response = await _postsRepo.getPost(postId: postId);
    response.fold(
      (left) {
        emit(GetPostErrorState(message: left.apiErrorModel.title ?? ""));
      },
      (right) {
        getPostResponse = right;
        getElapsedTime(getPostResponse!.createdAt, getPostResponse!.id);
        emit(GetPostSuccessState());
      },
    );
  }

  File? imageFile;

  void pickImageFromGallery() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      imageFile = File(picked.path);
    }
    emit(UploadImageStata());
  }

  void clearImage() async {
    imageFile = null;
    emit(UploadImageStata());
  }

  final addPostTextController = TextEditingController();

  void addPost({required String userId}) async {
    emit(AddPostLoadingState());
    final response = await _postsRepo.addPost(
        userId: userId,
        description: addPostTextController.text,
        imageFile: imageFile!);
    response.fold(
      (left) {
        emit(AddPostErrorState(message: left.apiErrorModel.title ?? ""));
      },
      (right) {
        final newPost = GetPostsResponseData(
          id: right.id,
          imagePath: right.imagePath,
          description: right.message,
          createdAt: DateTime.now().toIso8601String(),
          // Better date format
          applicationUserId: right.user.id,
            // ownerUserName:right.user.userName,ownerProfilePicture: right.user.profilePicture
        );

        // Update posts list
        getPostsResponse!.posts.insert(0, newPost); // Add to beginning of list
        isExpandedList =
            List.generate(getPostsResponse!.posts.length, (index) => false);

        emit(AddPostSuccessState(right));
      },
    );
  }

  void deletePost({required String postId}) async {
    emit(DeletePostLoadingState());
    final response = await _postsRepo.deletePost(postId: postId);
    response.fold(
      (left) {
        emit(DeletePostErrorState(message: left.apiErrorModel.title ?? ""));
      },
      (right) {
        getAllPostsResponse?.posts.removeWhere(
          (element) => element.id == postId,
        ); // Add to beginning of list
        getPostsResponse?.posts.removeWhere(
          (element) => element.id == postId,
        ); // Add to beginning of list

        emit(DeletePostSuccessState(right.message));
      },
    );
  }

  void getComment({required String postId}) async {
    emit(GetCommentLoadingState());
    final response = await _postsRepo.getCommentPost(postId: postId);
    response.fold(
      (left) {
        emit(GetCommentErrorState(message: left.apiErrorModel.title ?? ""));
      },
      (right) {
        getCommentResponse = right;
        emit(GetCommentSuccessState());
      },
    );
  }

  void addComment({required String postId}) async {
    emit(AddCommentLoadingState());
    final response = await _postsRepo.addComment(
        addCommentBody: AddCommentBody(
            content: commentController.text, portfolioPostId: postId), userId:await SharedPrefHelper.getString(SharedPrefKey.userId) );
    response.fold(
      (left) {
        emit(AddCommentErrorState(message: left.apiErrorModel.title ?? ""));
      },
      (right) {
        final newPost = CommentData(
          content: right.content,
          userId: right.userId,
          userName: right.userName,
          portfolioPostId: right.portfolioPostId, id: right.id, createdAt: right.createdAt,
          userProfilePicture: right.userProfilePicture
        );

        // Update posts list
        getCommentResponse!.comments.insert(0, newPost); // Add to beginning of list
        getElapsedTime(right.createdAt,right.id);

        Timer.periodic(const Duration(seconds:30), (_) {
          getElapsedTime(right.createdAt,right.id);
        });
        commentController.clear();

        emit(AddCommentSuccessState(right));
      },
    );
  }
  // String elapsedTime(dynamic dateTime){
  //
  //   timeMap[commentId]= time;
  // }

  void updateComment({required String commentId}) async {
    emit(UpdateCommentLoadingState());
    final response = await _postsRepo.updateComment(
  userId:await SharedPrefHelper.getString(SharedPrefKey.userId,),content:updateCommentController.text,commentId:commentId );
    response.fold(
          (left) {
        emit(UpdateCommentErrorState(message: left.apiErrorModel.title ?? ""));
      },
          (right) {
            for (int i = 0; i < getCommentResponse!.comments.length; i++) {
              if (getCommentResponse!.comments[i].id == right.id) {
                getCommentResponse!.comments[i] = getCommentResponse!.comments[i].copyWith(
                  content: right.content,
                );
                print("righttt ${right.content}");
                break;
              }
            }
            isEditingMap[commentId]=false;
            // emit(EditState());
            emit(UpdateCommentSuccessState(right));
      },
    );
  }

  void deleteComment({required String commentId}) async {
    emit(DeleteCommentLoadingState());
    final response = await _postsRepo.deleteComment(
        userId:await SharedPrefHelper.getString(SharedPrefKey.userId,),commentId:commentId );
    response.fold(
          (left) {
        emit(DeleteCommentErrorState(message: left.apiErrorModel.title ?? ""));
      },
          (right) {
            getCommentResponse!.comments.removeWhere((element) => element.id==commentId,);
        // emit(EditState());
        emit(DeleteCommentSuccessState(right));
      },
    );
  }
  // late TextEditingController _editController;
  Map<String,bool> isEditingMap={};
  late FocusNode focusNode;

  void startEditing({required String commentId}) {
    isEditingMap[commentId]=true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
    emit(EditState());
  }

  void cancelEdit({required String commentId}) {
    // _editController.text = widget.getCommentData.content;
    isEditingMap[commentId]=false;

    // isEditing = false;
    focusNode.unfocus();
      emit(EditState());

  }

  Map<String,String> timeMap={};
   void getElapsedTime(dynamic dateTime,String commentId) {

       // Convert to DateTime object if it's a string
       final DateTime parsedDateTime = dateTime is String
           ? DateTime.parse(dateTime)
           : dateTime;

       final now = DateTime.now();
       final difference = now.difference(parsedDateTime);

       // Calculate time units
       final seconds = difference.inSeconds;
       final minutes = difference.inMinutes;
       final hours = difference.inHours;
       final days = difference.inDays;
       final months = (days / 30).floor();
       final years = (days / 365).floor();

       // Return appropriate format based on elapsed time
       if (seconds < 60) {
         timeMap[commentId] = '$seconds seconds ago';
       } else if (minutes < 60) {
         minutes == 1
             ? timeMap[commentId] = 'a minute ago'
             : timeMap[commentId] = '$minutes minutes ago';
       } else if (hours < 24) {
         if (hours == 1) {
           timeMap[commentId] = 'an hour ago';
         } else if (hours == 2) {
           timeMap[commentId] = '2 hours ago';
         } else if (hours >= 3 && hours <= 10) {
           timeMap[commentId] = '$hours hours ago';
         } else {
           timeMap[commentId] = '$hours hours ago';
         }
       } else if (days < 30) {
         if (days == 1) {
           timeMap[commentId] = 'a day ago';
         } else if (days == 2) {
           timeMap[commentId] = '2 days ago';
         } else if (days >= 3 && days <= 10) {
           timeMap[commentId] = '$days days ago';
         } else {
           timeMap[commentId] = '$days days ago';
         }
       } else if (months < 12) {
         if (months == 1) {
           timeMap[commentId] = 'a month ago';
         } else if (months == 2) {
           timeMap[commentId] = '2 months ago';
         } else if (months >= 3 && months <= 10) {
           timeMap[commentId] = '$months months ago';
         } else {
           timeMap[commentId] = '$months months ago';
         }
       } else {
         if (years == 1) {
           timeMap[commentId] = 'a year ago';
         } else if (years == 2) {
           timeMap[commentId] = '2 years ago';
         } else if (years >= 3 && years <= 10) {
           timeMap[commentId] = '$years years ago';
         } else {
           timeMap[commentId] = '$years years ago';
         }
       }
       emit(ChangeTimeState());
       print("timeeeee ${ timeMap[commentId]}");
   }
  bool emojiShowing = false;

  void changeEmojiState() {
    emojiShowing = !emojiShowing;
    print("emojeeee ${emojiShowing}");
    emit(ChangeEmojiState());
  }
   Map<String,bool> isBookmarked= {};
  Map<String,bool> isFavorite= {};
  Map<String,bool> isDownloaded={};
  // void toggleBookmark() {
  //   isBookmarked=!isBookmarked;
  //   isFavorited=false;
  //   isDownloaded=false;
  //   emit(TogelState());
  // }
  //
  // void toggleFavorite() {
  //   isFavorited=!isFavorited;
  //   isDownloaded=false;
  //   isBookmarked=false;
  //   emit(TogelState());
  //
  // }
  //
  // void toggleDownload() {
  //   isDownloaded=!isDownloaded;
  //   isBookmarked=false;
  //   isFavorited=false;
  //
  //   emit(TogelState());
  //
  // }
  void download({required String imageUrl}) async {
    isDownloaded[imageUrl]=true;

    emit(DownloadLoadingState());
    final response = await _postsRepo.download(imageUrl: imageUrl
    );

    response.fold(
          (left) {
            isDownloaded[imageUrl]=!isDownloaded[imageUrl]!;
            print("errorrrrr ${left.apiErrorModel.title}");

            emit(DownloadErrorState(message: left.apiErrorModel.title ?? ""));
      },
          (right) {
            isDownloaded[imageUrl]=false;
            print("sucesssssssssss downloaddd");

        emit(DownloadSuccessState());
      },
    );

}
  void saveDesign({required String imageUrl}) async {
    isFavorite[imageUrl]=true;

    emit(SaveDesignLoadingState());
    final response = await _postsRepo.saveDesign(imageUrl: imageUrl, userId: await SharedPrefHelper.getString(SharedPrefKey.userId),
    );

    response.fold(
          (left) {
            isFavorite[imageUrl]=!isFavorite[imageUrl]!;
        print("errorrrrr ${left.apiErrorModel.title}");

        emit(SaveDesignErrorState(message: left.apiErrorModel.title ?? ""));
      },
          (right) {
            isFavorite[imageUrl]=false;
        print("sucesssssssssss downloaddd");

        emit(SaveDesignSuccessState());
      },
    );

  }
  Timer? _debounceTimer;

  SearchUserModel ?searchUserModel;
  void searchUser({required String query}) async {
    // إلغاء أي timer سابق
    _debounceTimer?.cancel();

    // إنشاء timer جديد
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) return;

      emit(SearchUserLoadingState());
      final response = await _postsRepo.searchUser(query: query);
      response.fold(
            (left) {
          emit(SearchUserErrorState(message: left.apiErrorModel.title ?? ""));
        },
            (right) {
          searchUserModel = right;
          emit(SearchUserSuccessState());
        },
      );
    });
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}