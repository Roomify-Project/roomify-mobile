import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../sign_up/data/repos/sign_repo.dart';
import '../../data/repos/profile_repo.dart';
import 'profile_states.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepo _profileRepo;

  ProfileCubit(this._profileRepo) : super(ProfileInitialState());

  static ProfileCubit get(context) => BlocProvider.of<ProfileCubit>(context);

  bool isDropdownOpen = false;
  bool? isFollowing ;
  void addFollow({required String followId}) async {
    isFollowing=!isFollowing!;
    // emit(AddFollowSuccessState(message: ""));
    final response=_profileRepo.addFollow(followId: followId);

    response.fold((left) {
      isFollowing=!isFollowing!;
      emit(AddFollowErrorState(message: left.apiErrorModel.title));
    }, (right) {

      emit(AddFollowSuccessState(message: right));
    },);
  }


  void checkISFollowing({required String followId}) async {
    final response=_profileRepo.checkIsFollowing(followId: followId);

    response.fold((left) {
      emit(GetIsFollowingErrorState(message: left.apiErrorModel.title));
    }, (right) {
      isFollowing=right.data;

      emit(GetIsFollowingSuccessState());
    },);
  }

  void changeDropDown(){
    isDropdownOpen=!isDropdownOpen;
    print(isDropdownOpen);
    emit(ChangeDropDownState());
  }
}