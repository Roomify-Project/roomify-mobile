import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/helpers/extensions.dart';
import 'package:rommify_app/core/routing/routes.dart';
import 'package:rommify_app/core/theming/styles.dart';
import 'package:rommify_app/core/widgets/custom_chached_network_image.dart';
import 'package:rommify_app/core/widgets/custom_shimmer.dart';
import 'package:rommify_app/features/create_room_screen/ui/widget/circle_widget.dart';
import 'package:rommify_app/features/profile/logic/cubit/profile_cubit.dart';
import 'package:rommify_app/features/profile/logic/cubit/profile_states.dart';

import '../../../core/helpers/constans.dart';
import '../../../core/helpers/shared_pref_helper.dart';
import '../../../core/theming/colors.dart';
import '../../../core/widgets/custom_empity_list.dart';
import '../../../core/widgets/custom_error.dart';
import '../data/models/get_follow_model.dart';

class FollowingScreen extends StatefulWidget {
  final ProfileCubit profileCubit;
  final String userId;

  const FollowingScreen({super.key, required this.profileCubit, required this.userId});

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    widget.profileCubit.getFollowingList(userId: widget.userId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.profileCubit,
      child: BlocBuilder<ProfileCubit, ProfileStates>(
        builder: (BuildContext context, state) {
          return WillPopScope(
            onWillPop: ()async {

              final userId = await SharedPrefHelper.getString(SharedPrefKey.userId);
              ProfileCubit.get(context).getFollowCount(followId: userId);
              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: ColorsManager.colorPrimary,
                leading: const Icon(Icons.arrow_back_ios,color: Colors.white,),
                centerTitle: true,
                title:  Text('Following',style: TextStyles.font18WhiteRegular,),
              ),
              backgroundColor: ColorsManager.colorPrimary,
              body: state is GetFollowingLoadingState
                  ? Padding(
                      padding: EdgeInsets.only(top: 50.h),
                      child: const Center(child: CustomShimmerEffect()),
                    )
                  : ProfileCubit.get(context).followingModel!.users.isEmpty ||
                          ProfileCubit.get(context).followingModel == null
                      ? const Center(
                          child: AnimatedEmptyList(
                            title: "No Following Found",
                            lottieAnimationPath:
                                'assets/animation/empity_list.json',
                          ),
                        )
                      : state is GetFollowingErrorState
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
                                itemCount: ProfileCubit.get(context).followingModel!.users.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () {
                                        context
                                            .pushNamed(Routes.profile,arguments: {
                                              'profileId': ProfileCubit.get(context).followersModel!.users[index].id,
                                        });
                                      },
                                      child: FollowItem(getFollowModelData:ProfileCubit.get(context).followingModel!.users[index] ,));
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
          );
        },
      ),
    );
  }
}

class FollowItem extends StatelessWidget {
  final GetFollowModelData getFollowModelData;

  const FollowItem({super.key, required this.getFollowModelData});
  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        context
            .pushNamed(Routes.profile,arguments: {
          'profileId': getFollowModelData.id
        });
      },
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
                  imageUrl:getFollowModelData.profilePicture,
                  fit: BoxFit.cover,
                  isDefault: true,
                )),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getFollowModelData.userName,
                style: TextStyles.font18WhiteRegular
              ),
              Text(
                getFollowModelData.bio,
                style: TextStyles.font10WhiteBold.copyWith(fontSize: 13.sp,color: Colors.grey,fontWeight: FontWeight.w500)
              ),

            ],
          ),
        ],
      ),
    );
  }
}
