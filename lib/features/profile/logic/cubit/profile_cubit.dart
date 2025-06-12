import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rommify_app/core/helpers/constans.dart';
import 'package:rommify_app/core/helpers/extensions.dart';
import 'package:rommify_app/core/routing/routes.dart';
import 'package:rommify_app/features/explore_screen/data/models/save_design_response.dart';
import 'package:rommify_app/features/profile/data/models/get_follow_count_model.dart';
import 'package:rommify_app/features/profile/data/models/get_follow_model.dart';
import 'package:rommify_app/features/profile/data/models/get_profile_data.dart';
import 'package:rommify_app/features/profile/data/models/update_profile_response.dart';

import '../../../../core/helpers/shared_pref_helper.dart';
import '../../../../core/widgets/signal_r_notification.dart';
import '../../data/models/get_history_design.dart';
import '../../data/models/saved_design_model.dart';
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
  SavedDesignsResponse? savedDesignResponse;
  Map<String,bool> isFollowingList={};
  bool? isFollow;
  ImageHistoryResponse? imageHistoryResponse;
  void changeFollow({required String followId}){
    print("changeee ${isFollowingList[followId]}");
    isFollowingList[followId]=! isFollowingList[followId]!;
    emit(ChangeFollowCount());
  }
  void addFollow({required String followId,bool isAdd=true}) async {
    isFollowingList[followId]=! isFollowingList[followId]!;
    isFollowing = !isFollowing!;
    // emit(AddFollowSuccessState(message: ""));
    final response = _profileRepo.addFollow(followId: followId);

    response.fold(
          (left) {
        print("followww errrorr ${left.apiErrorModel.title}");
        isFollowing = !isFollowing!;
        isFollowingList[followId]=! isFollowingList[followId]!;

        emit(AddFollowErrorState(message: left.apiErrorModel.title));
      },
          (right) {
            if(isAdd) {
              getFollowCountModel =
                  getFollowCountModel!.copyWith(
                    followers: getFollowCountModel!.followers + 1,
                  );
            }
            NotificationSignalRService.sendPushNotification(
                title: 'New Notification',
                body: "${SharedPrefHelper.getString(SharedPrefKey.name)} started following you.",
                userId: followId);
        isFollow=true;
        // checkISFollowing(followId: followId);
        emit(AddFollowSuccessState(message: right.message));
      },
    );
  }
  void unFollow({required String followId,bool isMinus=true}) async {
    isFollowingList[followId]=! isFollowingList[followId]!;

    isFollowing = !isFollowing!;
    // emit(AddFollowSuccessState(message: ""));
    final response = _profileRepo.unFollow(followId: followId);

    response.fold(
          (left) {
        print("followww errrorr ${left.apiErrorModel.title}");
        isFollowing = !isFollowing!;
        isFollowingList[followId]=! isFollowingList[followId]!;

        emit(AddFollowErrorState(message: left.apiErrorModel.title));
      },
          (right) {
            if(isMinus) {
              getFollowCountModel = getFollowCountModel!.copyWith(
                followers: getFollowCountModel!.followers - 1,
              );
            }
        isFollow=false;

        emit(AddFollowSuccessState(message: right.message));
      },
    );
  }

  void checkISFollowing({required String followId}) async {
    emit(GetIsFollowingLoadingState());
    final response = _profileRepo.checkIsFollowing(followId: followId);

    response.fold(
          (left) {
        emit(GetIsFollowingErrorState(message: left.apiErrorModel.title));
      },
          (right) {
        isFollowing = right.data;
        isFollowingList[followId]=right.data;
        print("is folllllow${isFollowingList[followId]}");

        emit(GetIsFollowingSuccessState());
      },
    );
  }

  void changeDropDown() {
    isDropdownOpen = !isDropdownOpen;
    print(isDropdownOpen);
    emit(ChangeDropDownState());
  }
  Map<String,bool> isDropdownOpenList={};
  void changeDropDownList({required String followId}) {
    isDropdownOpenList[followId] = !isDropdownOpenList[followId]!;
    print(isDropdownOpenList[followId]);
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
          id: right.user.id,
          userName: right.user.userName,
          fullName: right.user.fullName,
          bio: right.user.bio,
          email: right.user.email,
          emailConfirmed: right.user.emailConfirmed,
          phoneNumber: right.user.phoneNumber,
          role: getProfileDataModel!.role,
          profilePicture: right.user.profilePicture,
        );
        if(right.user.profilePicture!=null) {
          SharedPrefHelper.setData(
              SharedPrefKey.image, right.user.profilePicture);
        }
        emit(UpdateProfileSuccessState(updateProfileResponse: right));
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
          print("emitttttt");

      },
    );
  }
  int item=-1;
  void toggleProfile(int index){
    item=index;
    emit(ToggleProfile());
  }
  List<bool> isExpandedListHistory = [];
  List<bool> isExpandedListSaved = [];
  void getSavedDesign() async {
    emit(GetSavedLoadingState());
    final response = _profileRepo.getSavedDesign(userId: await SharedPrefHelper.getString(SharedPrefKey.userId));

    response.fold(
          (left) {
        emit(GetSavedErrorState(message: left.apiErrorModel.title));
      },
          (right) {
        savedDesignResponse=right;
        isExpandedListSaved =
            List.generate(right.savedDesigns.length, (index) => false);
        print("is folllllow${isFollowing}");

        emit(GetSavedSuccessState());
      },
    );
  }


  void getHistory() async {
    emit(GetHistoryLoadingState());
    final response = _profileRepo.getHistory(userId: await SharedPrefHelper.getString(SharedPrefKey.userId));

    response.fold(
          (left) {
        emit(GetHistoryErrorState(message: left.apiErrorModel.title));
      },
          (right) {

        imageHistoryResponse=right;
        isExpandedListHistory =
            List.generate(right.history.length, (index) => false);
        emit(GetHistorySuccessState());
      },
    );
  }
  GetFollowModel? followersModel;
  GetFollowModel? followingModel;

  void getFollowersList({required String userId}) async {
    emit(GetFollowersLoadingState());
    final response = _profileRepo.getFollowersList(userId: userId);

    response.fold(
          (left) {
        emit(GetFollowersErrorState(message: left.apiErrorModel.title));
      },
          (right) {
        followersModel=right;
        for(var i in followersModel!.users){
          isDropdownOpenList[i.id]=false;
        }
        emit(GetFollowersSuccessState());
      },
    );
  }
  void getFollowingList({required String userId}) async {
    emit(GetFollowingLoadingState());
    final response = _profileRepo.getFollowingList(userId: userId);

    response.fold(
          (left) {
        emit(GetFollowingErrorState(message: left.apiErrorModel.title));
      },
          (right) {
        followingModel=right;
        emit(GetFollowingSuccessState());
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
