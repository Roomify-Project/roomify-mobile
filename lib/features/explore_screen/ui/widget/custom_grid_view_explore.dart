import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/helpers/extensions.dart';
import 'package:rommify_app/core/routing/routes.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/login_states.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/posts_cubit.dart';

import '../../../../core/widgets/custom_empity_list.dart';
import '../../../../core/widgets/custom_error.dart';
import '../../../../core/widgets/custom_shimmer.dart';
import '../../../profile/profile.dart';

class CustomGridViewExplore extends StatefulWidget {
  const CustomGridViewExplore({super.key});

  @override
  State<CustomGridViewExplore> createState() => _CustomGridViewExploreState();
}

class _CustomGridViewExploreState extends State<CustomGridViewExplore> {
  late List<bool> isExpandedList;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PostsCubit.get(context).getAllPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final postsCubit = PostsCubit.get(context);

    return RefreshIndicator(
      onRefresh: () async {
         postsCubit.getAllPosts();
      },
      child: BlocBuilder<PostsCubit, PostsStates>(
        builder: (BuildContext context, state) {
          if (state is GetAllPostsLoadingState) {
            return const CustomShimmerEffect();
          }

          if (state is GetAllPostsErrorState) {
            print("stateeeee ${state.message}");
            return Center(
              child: AnimatedErrorWidget(
                title: "Loading Error",
                message: state.message ?? "No data available",
                lottieAnimationPath: 'assets/animation/error.json',
                onRetry: () => postsCubit.getAllPosts(),
              ),
            );
          }

          final posts = postsCubit.getAllPostsResponse?.posts;
          if (posts == null || posts.isEmpty) {
            return const Center(
              child: AnimatedEmptyList(
                title: "No Posts Found",
                subtitle: "Start by creating your first post",
                lottieAnimationPath: 'assets/animation/empity_list.json',
              ),
            );
          }

          // Initialize isExpandedList
          isExpandedList = List.generate(posts.length, (index) => false);

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
              return InkWell(
                onTap: () {
                  context.pushNamed(Routes.mainScreen,arguments: {
                    'postId':posts[index].id
                  });
                  },
                child: ImageCard(
                  imageUrl: posts[index].imagePath,
                  profileImageUrl: posts[index].imagePath,
                  onPressed: () {
                    context.pushNamed(Routes.profile,arguments: {'profileId':posts[index].applicationUserId});
                  },
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
//   final bool isExpanded;
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