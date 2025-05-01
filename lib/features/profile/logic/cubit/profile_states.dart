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