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


class CustomHistoryDesignGridViewProfile extends StatefulWidget {
  final String profileId;
  // final bool index;
  const CustomHistoryDesignGridViewProfile({super.key, required this.profileId});

  @override
  State<CustomHistoryDesignGridViewProfile> createState() => _CustomHistoryDesignGridViewProfileState();
}

class _CustomHistoryDesignGridViewProfileState extends State<CustomHistoryDesignGridViewProfile> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserPosts();
    });
  }

  void _loadUserPosts() {
    ProfileCubit.get(context).getHistory();

  }

  @override
  Widget build(BuildContext context) {
    final profileCubit = ProfileCubit.get(context);

    return BlocBuilder<PostsCubit,PostsStates>(
      builder: (BuildContext context, state) { 
        return RefreshIndicator(
          onRefresh: () async {
            _loadUserPosts();
          },
          child: BlocBuilder<ProfileCubit, ProfileStates>(
            builder: (BuildContext context, state) {
              // Loading State
              if (state is GetHistoryLoadingState) {
                return const Center(child: CustomShimmerEffect());
              }

              final history = profileCubit.imageHistoryResponse;

              // Error State
              if (state is GetHistoryErrorState ) {
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
              if (history == null || history.history.isEmpty) {
                return  const Center(
                  child: AnimatedEmptyList(
                    title: "No History Found",
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
                  itemCount: history.history.length,
                  itemBuilder: (context, index) {
                    final historyItem = history.history[index];
                    return InkWell(
                      onTap: () {
                        context.pushNamed(Routes.mainScreen,arguments: {
                          'postId':historyItem.id
                        });
                      },
                      child: ImageCard(
                        imageUrl: historyItem.generatedImageUrl,
                        profileImageUrl: 'assets/images/1O0A0210.jpg',
                        onExpand: () {
                          setState(() {
                            profileCubit.isExpandedListHistory[index] = !profileCubit.isExpandedListHistory[index];
                            // print(postsCubit.isExpandedList[index]);
                          });
                        },
                        isExpanded: profileCubit.isExpandedListHistory[index], postsCubit: PostsCubit.get(context),
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
