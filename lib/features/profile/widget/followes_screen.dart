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

class _FollowersScreenState extends State<FollowersScreen> with WidgetsBindingObserver {
  bool _wasInBackground = false;

  @override
  void initState() {
    print("intttttttt");
    widget.profileCubit.getFollowersList(userId: widget.userId);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _wasInBackground = true;
    } else if (state == AppLifecycleState.resumed && _wasInBackground) {
      // لما ترجع للـ app من background، هيحدث الـ followers
      widget.profileCubit.getFollowersList(userId: widget.userId);
      _wasInBackground = false;
    }
  }

  // أو استخدم دي بدل الـ AppLifecycle
  void _refreshFollowersList() {
    widget.profileCubit.getFollowersList(userId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider.value(
      value: widget.profileCubit,
      child: BlocBuilder<ProfileCubit, ProfileStates>(
        builder: (BuildContext context, state) {
          return WillPopScope(
            onWillPop: () async {
              final userId = await SharedPrefHelper.getString(SharedPrefKey.userId);

              if(widget.userId==userId) {
                print("yessssss");
                ProfileCubit.get(context).getFollowCount(
                    followId: widget.userId);
              }
              return true;
            },
            child: Scaffold(
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
                // إضافة refresh button في الـ AppBar
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: _refreshFollowersList,
                  ),
                ],
              ),
              backgroundColor: ColorsManager.colorPrimary,
              body: RefreshIndicator(
                // إضافة pull-to-refresh
                onRefresh: () async {
                  widget.profileCubit.getFollowersList(userId: widget.userId);
                },
                child: state is GetFollowersLoadingState
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
                        userId: widget.userId,
                        // تمرير الـ refresh function للـ FollowItem
                        onFollowStateChanged: _refreshFollowersList,
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
  final VoidCallback? onFollowStateChanged; // إضافة callback للـ refresh

  const FollowItem({
    super.key,
    required this.getFollowModelData,
    required this.userId,
    this.onFollowStateChanged,
  });

  @override
  State<FollowItem> createState() => _FollowItemState();
}

class _FollowItemState extends State<FollowItem> {
  @override
  void initState() {
    ProfileCubit.get(context)
        .checkISFollowing(followId: widget.getFollowModelData.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.getFollowModelData.id!=SharedPrefHelper.getString(SharedPrefKey.userId)?() async {
        // استخدام await للانتظار حتى الرجوع من الـ profile screen

          await context.pushNamed(Routes.profile, arguments: {
            'profileId': widget.getFollowModelData.id
          });


        // بعد الرجوع، نادي الـ refresh function
        if (widget.onFollowStateChanged != null) {
          widget.onFollowStateChanged!();
        }
      }:null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
                child: CustomCachedNetworkImage(
                  imageUrl:widget.getFollowModelData.profilePicture,
                  fit: BoxFit.cover,
                  isDefault: true,
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
              null&&widget.getFollowModelData.id!=SharedPrefHelper.getString(SharedPrefKey.userId)
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
              ProfileCubit.get(context).addFollow(
                  followId: widget.getFollowModelData.id);
            },
            child: widget.userId == SharedPrefHelper.getString(SharedPrefKey.userId)
                ? Text(
              'Follow Back',
              style: TextStyles.font16WhiteInter,
            )
                : Text(
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
                  ProfileCubit.get(context).changeDropDownList(followId: widget.getFollowModelData.id);
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
                      ProfileCubit.get(context).isDropdownOpenList[widget.getFollowModelData.id] ?? false
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.green,
                      size: 20,
                    ),
                  ],
                ),
              ),
              if (ProfileCubit.get(context).isDropdownOpenList[widget.getFollowModelData.id] ?? false)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      ProfileCubit.get(context).changeDropDownList(followId: widget.getFollowModelData.id);
                      ProfileCubit.get(context).unFollow(
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
              : const SizedBox()
        ],
      ),
    );
  }
}