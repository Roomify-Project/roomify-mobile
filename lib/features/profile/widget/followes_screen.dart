import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/helpers/constans.dart';
import 'package:rommify_app/core/helpers/extensions.dart';
import 'package:rommify_app/core/helpers/shared_pref_helper.dart';
import 'package:rommify_app/core/theming/styles.dart';
import 'package:rommify_app/core/widgets/custom_chached_network_image.dart';
import 'package:rommify_app/core/widgets/custom_shimmer.dart';
import 'package:rommify_app/features/create_room_screen/ui/widget/circle_widget.dart';
import 'package:rommify_app/features/profile/logic/cubit/profile_cubit.dart';
import 'package:rommify_app/features/profile/logic/cubit/profile_states.dart';

import '../../../core/routing/routes.dart';
import '../../../core/theming/colors.dart';
import '../../../core/widgets/custom_empity_list.dart';
import '../../../core/widgets/custom_error.dart';
import '../data/models/get_follow_model.dart';

class FollowersScreen extends StatefulWidget {
  final ProfileCubit profileCubit;
  final String userId;

  const FollowersScreen(
      {super.key, required this.profileCubit, required this.userId});

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  @override
  void initState() {
    // TODO: implement initState
    widget.profileCubit.getFollowersList(userId: widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.profileCubit,
      child: BlocBuilder<ProfileCubit, ProfileStates>(
        builder: (BuildContext context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: ColorsManager.colorPrimary,
              leading: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              centerTitle: true,
              title: Text(
                'Followers',
                style: TextStyles.font18WhiteRegular,
              ),
            ),
            backgroundColor: ColorsManager.colorPrimary,
            body: state is GetFollowersLoadingState
                ? Padding(
                    padding: EdgeInsets.only(top: 50.h),
                    child: const Center(child: CustomShimmerEffect()),
                  )
                : ProfileCubit.get(context).followersModel?.users.isEmpty ??
                        false ||
                            ProfileCubit.get(context).followersModel == null
                    ? const Center(
                        child: AnimatedEmptyList(
                          title: "No Followers Found",
                          lottieAnimationPath:
                              'assets/animation/empity_list.json',
                        ),
                      )
                    : state is GetFollowersErrorState
                        ? Center(
                            child: AnimatedErrorWidget(
                              title: "Loading Error",
                              message: state.message ?? "No data available",
                              lottieAnimationPath:
                                  'assets/animation/error.json',
                              // onRetry: () => postsCubit.getAllPosts(),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(
                                top: 30.h, right: 23.w, left: 23.w),
                            child: ListView.separated(
                              itemCount: ProfileCubit.get(context)
                                  .followersModel!
                                  .users
                                  .length,
                              itemBuilder: (context, index) {
                                return FollowItem(
                                  getFollowModelData:
                                      ProfileCubit.get(context)
                                          .followersModel!
                                          .users[index],
                                  userId:widget.userId
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  height: 30.h,
                                );
                              },
                            ),
                          ),
          );
        },
      ),
    );
  }
}

class FollowItem extends StatefulWidget {
  final GetFollowModelData getFollowModelData;
  final String userId;
  const FollowItem({super.key, required this.getFollowModelData, required this.userId,  });

  @override
  State<FollowItem> createState() => _FollowItemState();
}

class _FollowItemState extends State<FollowItem> {
  @override
  void initState() {
    // TODO: implement initState
    ProfileCubit.get(context)
        .checkISFollowing(followId: widget.getFollowModelData.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context
            .pushNamed(Routes.profile,arguments: {
          'profileId': widget.getFollowModelData.id
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25.r,
            child: ClipOval(
                child: CustomCachedNetworkImage(
              imageUrl: widget.getFollowModelData.profilePicture,
              isDefault: true,
              fit: BoxFit.cover,
              isZoom: false,
            )),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.getFollowModelData.userName,
                  style: TextStyles.font18WhiteRegular),
              Text(widget.getFollowModelData.bio,
                  style: TextStyles.font10WhiteBold.copyWith(
                      fontSize: 13.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          const Spacer(),
          ProfileCubit.get(context)
                      .isFollowingList[widget.getFollowModelData.id] !=
                  null
              ? !ProfileCubit.get(context)
                      .isFollowingList[widget.getFollowModelData.id]!
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.colorSecondry,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        print("ssssssssss");
                        ProfileCubit.get(context).addFollowMyProfile(
                            followId: widget.getFollowModelData.id);
                      },
                      child:
                      widget.userId==SharedPrefHelper.getString(SharedPrefKey.userId)?
                      Text(

                        'Follow Back',
                        style: TextStyles.font16WhiteInter,
                      ):
                      Text(
                        'Follow',
                        style: TextStyles.font16WhiteInter,
                      ),
                    )
                  : Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsManager.colorSecondry,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            ProfileCubit.get(context).changeDropDown();
                          },
                          child: Row(
                            children: [
                              Text(
                                'Following',
                                style: TextStyles.font16WhiteInter
                                    .copyWith(color: Colors.green),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                ProfileCubit.get(context).isDropdownOpen
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.green,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                        if (ProfileCubit.get(context).isDropdownOpen)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                ProfileCubit.get(context).changeDropDown();
                                ProfileCubit.get(context).unFollowMyProfile(
                                    followId: widget.getFollowModelData.id);
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Center(
                                child: Text("Unfollow",
                                    style: TextStyles.font16WhiteInter
                                        .copyWith(color: Colors.red)),
                              ),
                            ),
                          ),
                      ],
                    )
              : SizedBox()
        ],
      ),
    );
  }
}
