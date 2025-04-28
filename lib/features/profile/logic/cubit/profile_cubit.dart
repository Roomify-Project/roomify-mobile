import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rommify_app/features/profile/data/models/update_profile_response.dart';

import '../../data/models/update_profile_body.dart';
import '../../data/repos/profile_repo.dart';
import 'profile_states.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepo _profileRepo;

  ProfileCubit(this._profileRepo) : super(ProfileInitialState());

  static ProfileCubit get(context) => BlocProvider.of<ProfileCubit>(context);

  bool isDropdownOpen = false;
  UpdateProfileResponse? updateProfileResponse;
  bool? isFollowing;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  void addFollow({required String followId}) async {
    isFollowing = !isFollowing!;
    // emit(AddFollowSuccessState(message: ""));
    final response = _profileRepo.addFollow(followId: followId);

    response.fold(
      (left) {
        isFollowing = !isFollowing!;
        emit(AddFollowErrorState(message: left.apiErrorModel.title));
      },
      (right) {
        emit(AddFollowSuccessState(message: right));
      },
    );
  }

  void checkISFollowing({required String followId}) async {
    final response = _profileRepo.checkIsFollowing(followId: followId);

    response.fold(
      (left) {
        emit(GetIsFollowingErrorState(message: left.apiErrorModel.title));
      },
      (right) {
        isFollowing = right.data;

        emit(GetIsFollowingSuccessState());
      },
    );
  }

  void changeDropDown() {
    isDropdownOpen = !isDropdownOpen;
    print(isDropdownOpen);
    emit(ChangeDropDownState());
  }

  File? imageFile;

  void pickImage({required ImageSource source}) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      imageFile = File(picked.path);
      emit(UploadImageState());
    }
  }

  void clearImage() async {
    imageFile = null;
    emit(UploadImageState());
  }

  void updateProfile({required String updateProfileId}) async {
    emit(UpdateProfileLoadingState());
    final response = _profileRepo.updateProfile(
        updateProfileId: updateProfileId,
        updateProfileBody: UpdateProfileBody(
            userName: userNameController.text,
            fullName: fullNameController.text,
            bio: bioController.text,
            email: emailController.text,
            profilePicture: imageFile));

    response.fold(
      (left) {
        emit(UpdateProfileErrorState(message: left.apiErrorModel.title));
      },
      (right) {
        updateProfileResponse = right;
        emit(UpdateProfileSuccessState());
      },
    );
  }
}
