import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/helpers/constans.dart';
import 'package:rommify_app/core/helpers/extensions.dart';
import 'package:rommify_app/core/helpers/shared_pref_helper.dart';
import 'package:rommify_app/core/routing/routes.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/login_states.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/posts_cubit.dart';
import 'package:rommify_app/features/profile/logic/cubit/profile_cubit.dart';
import 'package:rommify_app/features/profile/logic/cubit/profile_states.dart';

import '../../../core/widgets/custom_empity_list.dart';
import '../../../core/widgets/custom_error.dart';
import '../../../core/widgets/custom_shimmer.dart';
import '../profile.dart';


class CustomSavedDesignGridViewProfile extends StatefulWidget {
  final String profileId;
  // final bool index;
  // final PostsCubit postsCubit;
  const CustomSavedDesignGridViewProfile({super.key, required this.profileId});

  @override
  State<CustomSavedDesignGridViewProfile> createState() => _CustomSavedDesignGridViewProfileState();
}

class _CustomSavedDesignGridViewProfileState extends State<CustomSavedDesignGridViewProfile> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserPosts();
    });
  }

  void _loadUserPosts() {
    ProfileCubit.get(context).getSavedDesign();

  }

  @override
  Widget build(BuildContext context) {
    final profileCubit = ProfileCubit.get(context);

    return BlocBuilder<PostsCubit,PostsStates>(
      builder: (BuildContext context, state) {
        final postsCubit=PostsCubit.get(context);
        return RefreshIndicator(
          onRefresh: () async {
            _loadUserPosts();
          },
          child: BlocBuilder<ProfileCubit, ProfileStates>(
            builder: (BuildContext context, state) {
              // Loading State
              if (state is GetSavedLoadingState) {
                return const Center(child: CustomShimmerEffect());
              }

              final savedDesign = profileCubit.savedDesignResponse;

              // Error State
              if (state is GetSavedErrorState ) {
                print("stateeeeee ${state.message}");
                return Center(
                  child: AnimatedErrorWidget(
                    title: "Loading Error",
                    message: state.message,
                    lottieAnimationPath: 'assets/animation/error.json',
                    onRetry: _loadUserPosts,
                  ),
                );
              }



              // Empty Posts State
              if (savedDesign == null || savedDesign.savedDesigns.isEmpty) {
                return  const Center(
                  child: AnimatedEmptyList(
                    title: "No Saved Found",
                    // subtitle: widget.profileId==SharedPrefHelper.getString(SharedPrefKey.userId)?"Start by creating your first post":"",
                    lottieAnimationPath: 'assets/animation/empity_list.json',
                  ),
                );
              }

              // Success State

              return
                GridView.builder(

                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 15,
                    childAspectRatio: 169 / 128,
                  ),
                  itemCount: savedDesign.savedDesigns.length,
                  itemBuilder: (context, index) {
                    final saved = savedDesign.savedDesigns[index];
                    return InkWell(
                      onTap: () {
                        context.pushNamed(Routes.mainScreen,arguments: {
                          'postId':saved.id
                        });
                      },
                      child: ImageCard(
                        imageUrl: saved.generatedImageUrl,
                        profileImageUrl:profileCubit.savedDesignResponse!.savedDesigns[index].userProfilePicture??"",
                        isZoom: false,
                        onExpand: () {
                          setState(() {
                            profileCubit.isExpandedListSaved[index] = !profileCubit.isExpandedListSaved[index];
                            // print(postsCubit.isExpandedList[index]);
                          });
                        },
                        isExpanded: profileCubit.isExpandedListSaved[index], postsCubit: postsCubit,
                      ),
                    );
                  },
                );
            },
          ),
        );
      },
    );
  }
}
