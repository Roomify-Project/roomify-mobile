import 'package:rommify_app/features/profile/data/models/update_profile_response.dart';

abstract class ProfileStates {}

class ProfileInitialState extends ProfileStates {}


////follow///////
class AddFollowLoadingState extends ProfileStates {}
class AddFollowSuccessState extends ProfileStates {
  final String message;
  AddFollowSuccessState({required this.message});
}
class AddFollowErrorState extends ProfileStates {
  final String message;
  AddFollowErrorState({required this.message});
}

////////check is follow///////////
class GetIsFollowingLoadingState extends ProfileStates {}
class GetIsFollowingSuccessState extends ProfileStates {
}
class GetIsFollowingErrorState extends ProfileStates {
  final String message;
  GetIsFollowingErrorState({required this.message});
}
class ChangeDropDownState extends ProfileStates {}


//// UPDATE PROFILE///////////
class UpdateProfileLoadingState extends ProfileStates {}
class UpdateProfileSuccessState extends ProfileStates {
  final UpdateProfileResponse updateProfileResponse;

  UpdateProfileSuccessState({required this.updateProfileResponse});
}
class UpdateProfileErrorState extends ProfileStates {
  final String message;
  UpdateProfileErrorState({required this.message});
}
class UploadImageState extends ProfileStates{}


//// Get PROFILE///////////
class GetUserDataProfileLoadingState extends ProfileStates {}
class GetUserDataProfileSuccessState extends ProfileStates {
}
class GetUserDataProfileErrorState extends ProfileStates {
  final String message;
  GetUserDataProfileErrorState({required this.message});
}

//// get follow count///
class GetFollowCountLoadingState extends ProfileStates {}
class GetFollowCountSuccessState extends ProfileStates {
}
class GetFollowCountErrorState extends ProfileStates {
  final String message;
  GetFollowCountErrorState({required this.message});
}

class GetSavedLoadingState extends ProfileStates {}
class GetSavedSuccessState extends ProfileStates {
}
class GetSavedErrorState extends ProfileStates {
  final String message;
  GetSavedErrorState({required this.message});
}

class GetHistoryLoadingState extends ProfileStates {}
class GetHistorySuccessState extends ProfileStates {
}
class GetHistoryErrorState extends ProfileStates {
  final String message;
  GetHistoryErrorState({required this.message});
}
class ToggleProfile extends ProfileStates {
}

class GetFollowersLoadingState extends ProfileStates {}
class GetFollowersSuccessState extends ProfileStates {
}
class GetFollowersErrorState extends ProfileStates {
  final String message;
  GetFollowersErrorState({required this.message});
}
class GetFollowingLoadingState extends ProfileStates {}
class GetFollowingSuccessState extends ProfileStates {
}
class GetFollowingErrorState extends ProfileStates {
  final String message;
  GetFollowingErrorState({required this.message});
}