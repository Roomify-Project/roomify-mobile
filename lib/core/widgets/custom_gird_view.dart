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
import '../theming/colors.dart';
import 'custom_chached_network_image.dart';
import 'custom_empity_list.dart';
import 'custom_error.dart';
import 'custom_shimmer.dart';
import 'flutter_show_toast.dart';

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