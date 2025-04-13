import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/helpers/constans.dart';
import 'package:rommify_app/core/helpers/extensions.dart';
import 'package:rommify_app/core/routing/routes.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/login_states.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/posts_cubit.dart';
import 'package:shimmer/shimmer.dart';

import '../../features/profile/profile.dart';
import 'custom_empity_list.dart';
import 'custom_error.dart';
import 'custom_shimmer.dart';

class CustomGridViewProfile extends StatefulWidget {
  const CustomGridViewProfile({super.key});

  @override
  State<CustomGridViewProfile> createState() => _CustomGridViewProfileState();
}

class _CustomGridViewProfileState extends State<CustomGridViewProfile> {
  late List<bool> isExpandedList;


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      PostsCubit.get(context).getUserPosts(
          id: SharedPrefKey.userId
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final postsCubit = PostsCubit.get(context);

    return RefreshIndicator(
      onRefresh: () async {
         PostsCubit.get(context).getUserPosts(
            id: SharedPrefKey.userId
        );
      },
      child: BlocBuilder<PostsCubit, PostsStates>(
        builder: (BuildContext context, state) {
          // Loading State
          if (state is GetUsePostsLoadingState) {
            return const CustomShimmerEffect();
          }

          // Null Response State
          if (state is GetUserPostsErrorState) {
            return  Center(
              child: AnimatedErrorWidget(
                title: "Loading Error",
                message: "No data available",
                lottieAnimationPath: 'assets/animation/error.json',
                onRetry: () {
                  PostsCubit.get(context).getUserPosts(
                      id: SharedPrefKey.userId
                  );
                },
              ),
            );
          }

          // Empty Posts State
         else if (postsCubit.getPostsResponse!=null&&postsCubit.getPostsResponse!.posts.isEmpty) {
            return const Center(
              child: AnimatedEmptyList(
                title: "No Posts Found",
                subtitle: "Start by creating your first post",
                lottieAnimationPath: 'assets/animation/empity_list.json',
              ),
            );
          }

          // // Error State
          // if (state is GetUserPostsErrorState) {
          //   return Center(
          //     child: AnimatedErrorWidget(
          //       title: "Error Occurred",
          //       message: state.message,
          //       lottieAnimationPath: 'assets/animation/error.json',
          //
          //     ),
          //   );
          // }

          else if(postsCubit.getPostsResponse!=null&&postsCubit.getPostsResponse!.posts.isNotEmpty) {
            // Initialize isExpandedList with actual data length
            isExpandedList = List.generate(
                postsCubit.getPostsResponse!.posts.length,
                    (index) => false
            );

            // Success State
            return GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 15, // Changed from previous value to 0
                childAspectRatio: 169 / 128, // Set the aspect ratio
              ),
              itemCount: postsCubit.getPostsResponse!.posts.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    context.pushNamed(Routes.mainScreen);
                  },
                  child: ImageCard(
                    imageUrl: postsCubit.getPostsResponse!.posts[index].imagePath,
                    profileImageUrl: 'assets/images/1O0A0210.jpg',
                    onExpand: () {
                      setState(() {
                        isExpandedList[index] = !isExpandedList[index];
                      });
                    },
                    isExpanded: isExpandedList[index],
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
//   final bool isExpanded;
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