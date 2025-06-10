import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/helpers/constans.dart';
import 'package:rommify_app/core/helpers/extensions.dart';
import 'package:rommify_app/core/routing/routes.dart';
import 'package:rommify_app/core/theming/colors.dart';
import 'package:rommify_app/core/widgets/custom_chached_network_image.dart';
import 'package:rommify_app/core/widgets/custom_shimmer.dart';
import 'package:rommify_app/core/widgets/flutter_show_toast.dart';
import 'package:rommify_app/features/create_room_screen/ui/widget/circle_widget.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/login_states.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/posts_cubit.dart';
import 'package:rommify_app/features/profile/data/repos/profile_repo.dart';
import 'package:rommify_app/features/profile/edit_profile_screen.dart';
import 'package:rommify_app/features/profile/logic/cubit/profile_cubit.dart';
import 'package:rommify_app/features/profile/logic/cubit/profile_states.dart';
import 'package:rommify_app/features/profile/widget/custom_saved_gird_view.dart';
import 'package:rommify_app/features/profile/widget/custome_history.dart';

import '../../core/di/dependency_injection.dart';
import '../../core/helpers/shared_pref_helper.dart';
import '../../core/theming/styles.dart';
import '../../core/widgets/custom_error.dart';
import '../../core/widgets/custom_gird_view.dart';
import '../../main_rommify.dart';

class ProfileScreen extends StatefulWidget  {
  final String profileId;

  const ProfileScreen({super.key, required this.profileId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();

}

class _ProfileScreenState extends State<ProfileScreen> {
  String? selectedIcon;
  bool showAddMore = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ProfileCubit(getIt.get<ProfileRepo>())
        ..checkISFollowing(followId: widget.profileId)
        ..getUserProfileData(profileId: widget.profileId)
        ..getFollowCount(followId: widget.profileId),
      child: BlocConsumer<ProfileCubit, ProfileStates>(
          listener: (BuildContext context, Object? state) {
        if (state is AddFollowSuccessState) {
          flutterShowToast(
              message: state.message, toastCase: ToastCase.success);
        } else if (state is AddFollowErrorState) {
          flutterShowToast(message: state.message, toastCase: ToastCase.error);
        }
      }, builder: (BuildContext context, state) {
        final profileCubit = ProfileCubit.get(context);
        return Scaffold(
            backgroundColor: ColorsManager.mainColor,
            body: state is GetUserDataProfileLoadingState
                ? const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Center(child: CustomShimmerEffect()),
                  )
                : profileCubit.getProfileDataModel != null
                    ? Stack(
                        children: [
                          CircleWidget(),
                          Padding(
                            padding: const EdgeInsets.only(top: 60),
                            child: Column(
                              children: [
                                // Image and info row
                                Padding(
                                  padding: EdgeInsets.only(left: 24.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 90.w,
                                        height: 90.h,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: ClipOval(
                                            child: CustomCachedNetworkImage(
                                                imageUrl: profileCubit
                                                                .getProfileDataModel
                                                                ?.profilePicture ==
                                                            null ||
                                                        profileCubit
                                                                .getProfileDataModel!
                                                                .profilePicture ==
                                                            ""
                                                    ? Constants
                                                        .defaultImagePerson
                                                    : profileCubit
                                                        .getProfileDataModel!
                                                        .profilePicture)),
                                      ),
                                      SizedBox(width: 20.w),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            profileCubit.getProfileDataModel!
                                                .userName,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            profileCubit
                                                .getProfileDataModel!.role,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.sp),
                                          ),
                                          Text(
                                            profileCubit
                                                .getProfileDataModel!.email,
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12.sp),
                                          ),
                                          SizedBox(height: 8.h),
                                          profileCubit.getFollowCountModel !=
                                                  null
                                              ? Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        context.pushNamed(
                                                            Routes
                                                                .followersScreen,
                                                            arguments: {
                                                              'profileCubit':
                                                                  profileCubit,
                                                              'userId': widget
                                                                  .profileId
                                                            });
                                                      },
                                                      child: Text(
                                                          "${profileCubit.getFollowCountModel!.followers} followers",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize:
                                                                  14.sp)),
                                                    ),
                                                    SizedBox(width: 20.w),
                                                    InkWell(
                                                      onTap: () {
                                                        context.pushNamed(
                                                            Routes
                                                                .followingScreen,
                                                            arguments: {
                                                              'profileCubit':
                                                                  profileCubit,
                                                              'userId': widget
                                                                  .profileId
                                                            });
                                                      },
                                                      child: Text(
                                                          "${profileCubit.getFollowCountModel!.following} following",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize:
                                                                  14.sp)),
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                profileCubit.getProfileDataModel!.id !=
                                        SharedPrefHelper.getString(
                                            SharedPrefKey.userId)
                                    ? profileCubit.isFollowing != null
                                        ? Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 30.0.w),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: !profileCubit
                                                              .isFollowing!
                                                          ? ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                backgroundColor:
                                                                    ColorsManager
                                                                        .colorSecondry,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(8),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                profileCubit.addFollow(
                                                                    followId:
                                                                        widget
                                                                            .profileId,isAdd: true);
                                                              },
                                                              child: Text(
                                                                'Follow',
                                                                style: TextStyles
                                                                    .font16WhiteInter,
                                                              ),
                                                            )
                                                          : Column(
                                                              children: [
                                                                ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        ColorsManager
                                                                            .colorSecondry,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(8),
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    profileCubit
                                                                        .changeDropDown();
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        'Following',
                                                                        style: TextStyles
                                                                            .font16WhiteInter
                                                                            .copyWith(color: Colors.green),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              4),
                                                                      Icon(
                                                                        profileCubit.isDropdownOpen
                                                                            ? Icons.keyboard_arrow_up
                                                                            : Icons.keyboard_arrow_down,
                                                                        color:
                                                                            Colors.green,
                                                                        size:
                                                                            20,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                if (profileCubit
                                                                    .isDropdownOpen)
                                                                  Container(
                                                                    width:
                                                                        170.w,
                                                                    height:
                                                                        40.h,
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            1),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: ColorsManager
                                                                          .colorSecondry,
                                                                      borderRadius:
                                                                          BorderRadius.circular(8),
                                                                    ),
                                                                    child:
                                                                        Material(
                                                                      color: Colors
                                                                          .transparent,
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () {
                                                                          profileCubit.changeDropDown();
                                                                          profileCubit.unFollow(followId: widget.profileId,isMinus: true);
                                                                        },
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text("Unfollow", style: TextStyles.font16WhiteInter.copyWith(color: Colors.red)),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                    ),
                                                    SizedBox(width: 10.w),
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              ColorsManager
                                                                  .colorSecondry,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          context.pushNamed(
                                                              Routes
                                                                  .chatsFriendsScreen,
                                                              arguments: {
                                                                'getProfileDataModel':
                                                                    profileCubit
                                                                        .getProfileDataModel
                                                              });
                                                        },
                                                        child: Text(
                                                          'Message',
                                                          style: TextStyles
                                                              .font16WhiteInter,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 18.h),
                                            ],
                                          )
                                        : const SizedBox()
                                    : const SizedBox(),

                                // Interactive icons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    profileCubit.getProfileDataModel!.id ==
                                            SharedPrefHelper.getString(
                                                SharedPrefKey.userId)
                                        ? _buildIcon(Icons.add, -1, () {
                                            context.pushNamed(Routes.addPost);
                                          }, profileCubit)
                                        : const SizedBox(),
                                    SizedBox(width: 30.w),
                                    _buildIcon(Icons.favorite, 0, () {
                                      profileCubit.toggleProfile(0);
                                    }, profileCubit),
                                    SizedBox(width: 30.w),
                                    _buildIcon(Icons.history, 1, () {
                                      profileCubit.toggleProfile(1);
                                    }, profileCubit),
                                    SizedBox(width: 30.w),
                                    _buildIcon(Icons.bookmark, 2, () {
                                      profileCubit.toggleProfile(2);
                                    }, profileCubit),
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                // Image Grid - Modified mainAxisSpacing to 0

                                Expanded(
                                    child: profileCubit.item == -1
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                left: 23.w, right: 23.w),
                                            child: CustomGridViewProfile(
                                              profileId: widget.profileId,
                                            ),
                                          )
                                        : profileCubit.item == 0
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    left: 23.w, right: 23.w),
                                                child:
                                                    CustomSavedDesignGridViewProfile(
                                                        profileId:
                                                            widget.profileId),
                                              )
                                            : Padding(
                                                padding: EdgeInsets.only(
                                                    left: 23.w, right: 23.w),
                                                child:
                                                    CustomHistoryDesignGridViewProfile(
                                                        profileId:
                                                            widget.profileId),
                                              ))
                              ],
                            ),
                          ),
                          profileCubit.getProfileDataModel!.id ==
                                  SharedPrefHelper.getString(
                                      SharedPrefKey.userId)
                              ? Positioned(
                                  top: 25.h,
                                  right: 10.w,
                                  child: Row(
                                    children: [
                                      // InkWell(
                                      //   child: Icon(
                                      //     Icons.email_outlined,
                                      //     color: Colors.white,
                                      //     size: 28.sp,
                                      //   ),
                                      //   onTap: () {
                                      //     context.pushNamed(Routes.chatsScreen);
                                      //   },
                                      // ),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditProfileScreen(
                                                          profileCubit:
                                                              profileCubit,
                                                        )));
                                          },
                                          child: Icon(Icons.settings,
                                              color: Colors.white,
                                              size: 28.sp)),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      )
                    : state is GetUserDataProfileErrorState
                        ? Center(
                            child: AnimatedErrorWidget(
                              title: "Loading Error",
                              message: state.message,
                              lottieAnimationPath:
                                  'assets/animation/error.json',
                              onRetry: () {
                                profileCubit.getUserProfileData(
                                    profileId: widget.profileId);
                              },
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Center(child: CustomShimmerEffect()),
                          ));
      }),
    );
  }

  // Method to build icons that change color when tapped
  Widget _buildIcon(
      IconData icon, int index, VoidCallback onTap, ProfileCubit profileCubit) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // selectedIcon = key;
        });
        onTap.call();
      },
      child: Icon(
        icon,
        color: profileCubit.item == index ? Colors.white : Colors.grey,
        size: 35.h,
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  final String imageUrl;
  final String profileImageUrl;
  final VoidCallback onExpand;
  final bool isExpanded;
  final PostsCubit postsCubit;
  final Function()? onPressed;
  final bool isProfile;
  final BoxFit fit;
  final bool isZoom;

  const ImageCard({
    super.key,
    required this.imageUrl,
    required this.profileImageUrl,
    required this.onExpand,
    required this.isExpanded,
    this.onPressed,
    required this.postsCubit,
    this.isProfile = false,
    this.fit = BoxFit.cover,
    this.isZoom = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostsCubit, PostsStates>(
      listener: (context, state) {
        if (state is DownloadErrorState) {
          flutterShowToast(message: state.message, toastCase: ToastCase.error);
        } else if (state is DownloadSuccessState) {
          flutterShowToast(
              message: "Download successfully", toastCase: ToastCase.success);
        } else if (state is SaveDesignSuccessState) {
          flutterShowToast(
              message: "Saved successfully", toastCase: ToastCase.success);
        } else if (state is SaveDesignErrorState) {
          flutterShowToast(message: state.message, toastCase: ToastCase.error);
        }
      },
      builder: (BuildContext context, state) {
        return Stack(
          children: [
            Center(
              child: Container(
                width: 169.w,
                height: 128.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  // image: DecorationImage(
                  //   image: NetworkImage(imageUrl),
                  //   fit: BoxFit.cover,
                  // ),
                ),
                child: CustomCachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: fit,
                  isZoom: isZoom,
                  borderRadius: 10,
                ),
              ),
            ),
            isProfile
                ? Positioned(
                    top: 10.w,
                    left: 8.w,
                    child: InkWell(
                      onTap: onPressed,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                            child: CustomCachedNetworkImage(
                          imageUrl: profileImageUrl,
                          fit: BoxFit.cover,
                          width: 20.w,
                          height: 20.h,
                          isDefault: true,
                        )),
                      ),
                    ),
                  )
                : SizedBox(),
            Positioned(
              top: 10,
              right: 8,
              child: GestureDetector(
                onTap: onExpand,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isExpanded)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            child: Icon(Icons.bookmark_border,
                                color: false ? Colors.red : ColorsManager.white,
                                size: 20),
                            onTap: () {
                              // postsCubit.toggleBookmark();
                            },
                          ),
                          SizedBox(width: 10.w),
                          InkWell(
                            onTap: () {
                              postsCubit.saveDesign(imageUrl: imageUrl);
                            },
                            child: Icon(Icons.favorite_border,
                                color: postsCubit.isFavorite[imageUrl] ?? false
                                    ? Colors.red
                                    : ColorsManager.white,
                                size: 20),
                          ),
                          SizedBox(width: 10.w),
                          InkWell(
                              onTap: () {
                                postsCubit.download(imageUrl: imageUrl);
                              },
                              child: Icon(Icons.download,
                                  color:
                                      postsCubit.isDownloaded[imageUrl] ?? false
                                          ? Colors.red
                                          : ColorsManager.white,
                                  size: 20)),
                          SizedBox(width: 10.w),
                        ],
                      ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ColorsManager.white,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.more_horiz,
                        color: ColorsManager.white,
                        size: 12.sp,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
