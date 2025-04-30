import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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

  void getAllPosts() async {
    emit(GetAllPostsLoadingState());
    final response = await _postsRepo.getAllPosts();
    response.fold(
      (left) {
        print("leftttt ${ left.apiErrorModel.title}");
        emit(GetAllPostsErrorState(message: left.apiErrorModel.title));
      },
      (right) {
        getAllPostsResponse = right;
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

        print("sucessssss ${getAllPostsResponse!.posts}");
        getPostsResponse = right;

        emit(GetUserPostsSuccessState());
      },
    );
  }

  void getPost({required String postId}) async {
    emit(GetPostLoadingState());
    final response = await _postsRepo.getPost(postId: postId);
    response.fold(
      (left) {
        emit(GetPostErrorState(message: left.apiErrorModel.title ?? ""));
      },
      (right) {
        getPostResponse = right;
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
          imagePath: right.imageUrl,
          description: right.description,
          createdAt: DateTime.now().toIso8601String(), // Better date format
          applicationUserId: right.applicationUserId,
        );

        // Update posts list
        getPostsResponse!.posts.insert(0, newPost); // Add to beginning of list
        isExpandedList = List.generate(getPostsResponse!.posts.length, (index) => false);

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


        getAllPostsResponse?.posts.removeWhere((element) =>  element.id==postId,); // Add to beginning of list
        getPostsResponse?.posts.removeWhere((element) =>  element.id==postId,); // Add to beginning of list

        emit(DeletePostSuccessState(right.message));
      },
    );
  }
}
