import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rommify_app/core/helpers/extensions.dart';
import 'package:rommify_app/core/routing/routes.dart';
import 'package:rommify_app/features/profile/data/models/get_follow_count_model.dart';
import 'package:rommify_app/features/profile/data/models/get_profile_data.dart';
import 'package:rommify_app/features/profile/data/models/update_profile_response.dart';

import '../../../../core/helpers/shared_pref_helper.dart';
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
  GetProfileDataModel? getProfileDataModel;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  GetFollowCountModel? getFollowCountModel;

  void addFollow({required String followId}) async {
    isFollowing = !isFollowing!;
    // emit(AddFollowSuccessState(message: ""));
    final response = _profileRepo.addFollow(followId: followId);

    response.fold(
      (left) {
        print("followww errrorr ${left.apiErrorModel.title}");
        isFollowing = !isFollowing!;
        emit(AddFollowErrorState(message: left.apiErrorModel.title));
      },
      (right) {
        emit(AddFollowSuccessState(message: right.message));
      },
    );
  }

  void unFollow({required String followId}) async {
    isFollowing = !isFollowing!;
    // emit(AddFollowSuccessState(message: ""));
    final response = _profileRepo.unFollow(followId: followId);

    response.fold(
      (left) {
        print("followww errrorr ${left.apiErrorModel.title}");
        isFollowing = !isFollowing!;
        emit(AddFollowErrorState(message: left.apiErrorModel.title));
      },
      (right) {
        emit(AddFollowSuccessState(message: right.message));
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
        print("is folllllow${isFollowing}");

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
        ),
        imageProfile: imageFile);

    response.fold(
      (left) {
        emit(UpdateProfileErrorState(message: left.apiErrorModel.title));
      },
      (right) {
        updateProfileResponse = right;
        getProfileDataModel = GetProfileDataModel(
            id: right.id,
            userName: right.userName,
            fullName: right.fullName,
            bio: right.bio,
            email: right.email,
            emailConfirmed: right.emailConfirmed,
            phoneNumber: right.phoneNumber,
            role: getProfileDataModel!.role);
        emit(UpdateProfileSuccessState());
      },
    );
  }

  void getUserProfileData({required String profileId}) async {
    emit(GetUserDataProfileLoadingState());
    final response = _profileRepo.getProfileData(profileId: profileId);

    response.fold(
      (left) {
        emit(GetUserDataProfileErrorState(message: left.apiErrorModel.title));
      },
      (right) {
        getProfileDataModel = right;
        fullNameController.text = right.fullName;
        bioController.text = right.bio;
        userNameController.text = right.userName;
        emailController.text = right.email;
        phoneNumberController.text = right.phoneNumber ?? "Phone Number";

        emit(GetUserDataProfileSuccessState());
      },
    );
  }

  void getFollowCount({required String followId}) async {
    emit(GetFollowCountLoadingState());
    final response = _profileRepo.getFollowCount(followId: followId);

    response.fold(
      (left) {
        emit(GetFollowCountErrorState(message: left.apiErrorModel.title));
      },
      (right) {
        getFollowCountModel = right;
        print("is folllllow${isFollowing}");

        emit(GetFollowCountSuccessState());
      },
    );
  }

  Future<void> logOut({required BuildContext context}) async {
    await SharedPrefHelper.clearData();
    context.pushNamedAndRemoveUntil(Routes.loginScreen,
        predicate: (Route<dynamic> route) => false);
    print("tokennnn ${SharedPrefHelper.getString('token')}");
  }
}
