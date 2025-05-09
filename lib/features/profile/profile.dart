import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:rommify_app/features/profile/data/repos/profile_repo.dart';
import 'package:rommify_app/features/profile/edit_profile_screen.dart';
import 'package:rommify_app/features/profile/logic/cubit/profile_cubit.dart';
import 'package:rommify_app/features/profile/logic/cubit/profile_states.dart';

import '../../core/di/dependency_injection.dart';
import '../../core/helpers/shared_pref_helper.dart';
import '../../core/theming/styles.dart';
import '../../core/widgets/custom_error.dart';
import '../../core/widgets/custom_gird_view.dart';

class ProfileScreen extends StatefulWidget {
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
        ..getUserProfileData(profileId: widget.profileId),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 90,
                                      height: 90,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: ClipOval(
                                          child: CustomCachedNetworkImage(
                                              imageUrl: profileCubit
                                                  .getProfileDataModel!
                                                  .profilePicture)),
                                    ),
                                    SizedBox(width: 20.w),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          profileCubit
                                              .getProfileDataModel!.userName,
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
                                        const Row(
                                          children: [
                                            Text("1.3k followers",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14)),
                                            SizedBox(width: 20),
                                            Text("45 following",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                profileCubit.getProfileDataModel!.id !=
                                    SharedPrefHelper.getString(SharedPrefKey.userId)
                                    ? profileCubit.isFollowing != null
                                        ? Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 30.0.w),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child:
                                                          !profileCubit
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
                                                                          BorderRadius.circular(
                                                                              8),
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    profileCubit.addFollow(
                                                                        followId:
                                                                        widget.profileId);
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
                                                                            ColorsManager.colorSecondry,
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
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Text(
                                                                            'Following',
                                                                            style:
                                                                                TextStyles.font16WhiteInter.copyWith(color: Colors.green),
                                                                          ),
                                                                          const SizedBox(
                                                                              width: 4),
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
                                                                          color:
                                                                              ColorsManager.colorSecondry,
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                        ),
                                                                        child:
                                                                            Material(
                                                                          color:
                                                                              Colors.transparent,
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () {
                                                                              profileCubit.changeDropDown();
                                                                              profileCubit.unFollow(followId: widget.profileId);
                                                                            },
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                            child:
                                                                                Center(
                                                                              child: Text("Unfollow", style: TextStyles.font16WhiteInter.copyWith(color: Colors.red)),
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
                                                        onPressed: () {},
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
                                        SharedPrefHelper.getString(SharedPrefKey.userId)?
                                    _buildIcon(Icons.add, 'Add', () {
                                      context.pushNamed(Routes.addPost);

                                    }):const SizedBox(),
                                    SizedBox(width: 30.w),
                                    _buildIcon(
                                        Icons.favorite, 'favorite', () {}),
                                    SizedBox(width: 30.w),
                                    _buildIcon(Icons.history, 'history', () {}),
                                    SizedBox(width: 30.w),
                                    _buildIcon(
                                        Icons.bookmark, 'bookmark', () {}),
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                // Image Grid - Modified mainAxisSpacing to 0
                                 Expanded(
                                  child: CustomGridViewProfile(profileId: widget.profileId,),
                                ),
                              ],
                            ),
                          ),
                          profileCubit.getProfileDataModel!.id ==
                              SharedPrefHelper.getString(SharedPrefKey.userId)?
                          Positioned(
                            top: 25.h,
                            right: 10.w,
                            child: Row(
                              children: [
                                InkWell(
                                  child: Icon(
                                    Icons.email_outlined,
                                    color: Colors.white,
                                    size: 28.sp,
                                  ),
                                  onTap: () {
                                    context.pushNamed(Routes.chatsScreen);
                                  },
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProfileScreen(
                                                    profileCubit: profileCubit,
                                                  )));
                                    },
                                    child: Icon(Icons.settings,
                                        color: Colors.white, size: 28.sp)),
                              ],
                            ),
                          ):const SizedBox(),
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
  Widget _buildIcon(IconData icon, String key, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIcon = key;
        });
        onTap.call();
      },
      child: Icon(
        icon,
        color: selectedIcon == key ? Colors.white : Colors.grey,
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
  final Function()? onPressed;
  const ImageCard({
    super.key,
    required this.imageUrl,
    required this.profileImageUrl,
    required this.onExpand,
    required this.isExpanded,  this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            // image: DecorationImage(
            //   image: NetworkImage(imageUrl),
            //   fit: BoxFit.cover,
            // ),
          ),
          child: CustomCachedNetworkImage(
            imageUrl: imageUrl,
            width: 169,
            height: 128,
            fit: BoxFit.cover,
            borderRadius: 10,
          ),
        ),
        Positioned(
          top: 8.w,
          left: 8.w,
          child: InkWell(
            onTap: onPressed,
            child: Container(
              width: 24.w,
              height: 24.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
                child: ClipOval(child: CustomCachedNetworkImage(imageUrl: profileImageUrl)),
            ),
          ),
        ),
        Positioned(
          top: 8,
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
                      const Icon(Icons.bookmark_border,
                          color: ColorsManager.colorPrimary, size: 20),
                      SizedBox(width: 10.w),
                      const Icon(Icons.favorite_border,
                          color: ColorsManager.colorPrimary, size: 20),
                      SizedBox(width: 10.w),
                      InkWell(
                          onTap: () {},
                          child: Icon(Icons.download,
                              color: ColorsManager.colorPrimary, size: 20)),
                      SizedBox(width: 10.w),
                    ],
                  ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorsManager.colorPrimary,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.more_horiz,
                    color: ColorsManager.colorPrimary,
                    size: 14,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
