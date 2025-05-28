import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/helpers/constans.dart';
import 'package:rommify_app/core/helpers/extensions.dart';
import 'package:rommify_app/core/helpers/shared_pref_helper.dart';
import 'package:rommify_app/core/routing/routes.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/login_states.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/posts_cubit.dart';
import 'package:shimmer/shimmer.dart';

import '../../features/profile/profile.dart';
import 'custom_empity_list.dart';
import 'custom_error.dart';
import 'custom_shimmer.dart';

class CustomGridViewProfile extends StatefulWidget {
  final String profileId;
  const CustomGridViewProfile({super.key, required this.profileId});

  @override
  State<CustomGridViewProfile> createState() => _CustomGridViewProfileState();
}

class _CustomGridViewProfileState extends State<CustomGridViewProfile> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserPosts();
    });
  }

  void _loadUserPosts() {
    PostsCubit.get(context).getUserPosts(id: SharedPrefHelper.getString(SharedPrefKey.userId));
  }

  @override
  Widget build(BuildContext context) {
    final postsCubit = PostsCubit.get(context);

    return RefreshIndicator(
      onRefresh: () async {
        _loadUserPosts();
      },
      child: BlocBuilder<PostsCubit, PostsStates>(
        builder: (BuildContext context, state) {
          // Loading State
          if (state is GetUsePostsLoadingState) {
            return const Center(child: CustomShimmerEffect());
          }

          final posts = postsCubit.getPostsResponse?.posts;

          // Error State
          if (state is GetUserPostsErrorState) {
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
          if (posts == null || posts.isEmpty) {
            return  Center(
              child: AnimatedEmptyList(
                title: "No Posts Found",
                subtitle: widget.profileId==SharedPrefHelper.getString(SharedPrefKey.userId)?"Start by creating your first post":"",
                lottieAnimationPath: 'assets/animation/empity_list.json',
              ),
            );
          }

          // Success State

          return GridView.builder(

            padding: EdgeInsets.symmetric(horizontal: 10.w),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 15,
              childAspectRatio: 169 / 128,
            ),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return InkWell(
                onTap: () {
                  context.pushNamed(Routes.mainScreen,arguments: {
                    'postId':posts[index].id
                  });
                },
                child: ImageCard(
                  imageUrl: post.imagePath,
                  profileImageUrl: post.ownerProfilePicture??"",
                  onExpand: () {
                    setState(() {
                      postsCubit.isExpandedList[index] = !postsCubit.isExpandedList[index];
                      print(postsCubit.isExpandedList[index]);
                    });
                  },
                  isExpanded: postsCubit.isExpandedList[index], postsCubit: postsCubit,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
