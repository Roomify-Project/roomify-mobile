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
                  profileImageUrl: 'assets/images/1O0A0210.jpg',
                  onExpand: () {
                    setState(() {
                      postsCubit.isExpandedList[index] = !postsCubit.isExpandedList[index];
                      print(postsCubit.isExpandedList[index]);
                    });
                  },
                  isExpanded: postsCubit.isExpandedList[index],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
// ImageCard Widget
// class ImageCard extends StatelessWidget {
//   final String imageUrl;
//   final String profileImageUrl;
//   final VoidCallback onExpand;
//
//   const ImageCard({
//     Key? key,
//     required this.imageUrl,
//     required this.profileImageUrl,
//     required this.onExpand,
//     required this.isExpanded,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       child: Stack(
//         children: [
//           // Main Image
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12.r),
//             child: CachedNetworkImage(
//               imageUrl: imageUrl,
//               fit: BoxFit.cover,
//               width: double.infinity,
//               height: double.infinity,
//               placeholder: (context, url) => const ShimmerEffect(),
//               errorWidget: (context, url, error) => const Icon(
//                 Icons.error,
//                 color: Colors.red,
//               ),
//             ),
//           ),
//
//           // Profile Image
//           Positioned(
//             top: 8.h,
//             left: 8.w,
//             child: CircleAvatar(
//               radius: 16.r,
//               backgroundImage: CachedNetworkImageProvider(profileImageUrl),
//             ),
//           ),
//
//           // Expand Button
//           Positioned(
//             bottom: 8.h,
//             right: 8.w,
//             child: IconButton(
//               icon: Icon(
//                 isExpanded ? Icons.expand_less : Icons.expand_more,
//                 color: Colors.white,
//               ),
//               onPressed: onExpand,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ShimmerEffect Widget
// class ShimmerEffect extends StatelessWidget {
//   const ShimmerEffect({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Container(
//         color: Colors.white,
//       ),
//     );
//   }
// }