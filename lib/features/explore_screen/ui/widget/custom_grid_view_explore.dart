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
import '../../data/models/get_posts_response.dart';

class CustomGridViewExplore extends StatefulWidget {
  const CustomGridViewExplore({super.key});

  @override
  State<CustomGridViewExplore> createState() => _CustomGridViewExploreState();
}

class _CustomGridViewExploreState extends State<CustomGridViewExplore> {
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
            return Center(
              child: AnimatedErrorWidget(
                title: "Loading Error",
                message: state.message ?? "No data available",
                lottieAnimationPath: 'assets/animation/error.json',
                onRetry: () => postsCubit.getAllPosts(),
              ),
            );
          }

          final posts = postsCubit.getAllPostsResponse?.posts ?? [];
          final savedDesigns =
              postsCubit.getAllPostsResponse?.savedDesigns ?? [];

          if (posts.isEmpty && savedDesigns.isEmpty) {
            return const Center(
              child: AnimatedEmptyList(
                title: "No Posts Found",
                subtitle: "Start by creating your first post",
                lottieAnimationPath: 'assets/animation/empity_list.json',
              ),
            );
          }

          // دمج البوستات والتصاميم
          final combinedList = [
            ...posts.map((e) => CombinedPost(post: e)),
            ...savedDesigns.map((e) => CombinedPost(saved: e)),
          ];

          // تأكد إن قائمة التوسيع بنفس الطول
          // postsCubit.ensureExpandedListLength(combinedList.length);

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 15,
              childAspectRatio: 169 / 128,
            ),
            itemCount: posts.length+savedDesigns.length,
            itemBuilder: (context, index) {
              final item = combinedList[index];

              final imageUrl = item.isPost
                  ? item.post!.imagePath
                  : item.saved!.generatedImageUrl;

              final profileImage = item.isPost
                  ? item.post!.userProfilePicture ?? ""
                  : item.saved!.userProfilePicture ?? "";

              final userId =
              item.isPost ? item.post!.userId : item.saved!.userId;

              final id = item.isPost ? item.post!.id : item.saved!.id;

              return InkWell(
                onTap: () {
                  context.pushNamed(Routes.mainScreen, arguments: {
                    'postId': id,
                    'isPost':item.isPost
                  });
                },
                child: ImageCard(
                  isZoom: false,
                  isProfile: true,
                  isLove: true,
                  imageUrl: imageUrl,
                  profileImageUrl: profileImage,
                  onPressed: () {
                    context.pushNamed(Routes.profile,
                        arguments: {'profileId': userId});
                  },
                  onExpand: () {
                    setState(() {
                      postsCubit.isExpandedListExploreScreen[index] =
                      !postsCubit.isExpandedListExploreScreen[index];
                    });
                  },
                  isExpanded: postsCubit.isExpandedListExploreScreen[index],
                  postsCubit: postsCubit,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// الكلاس الموحّد
class CombinedPost {
  final PortfolioPost? post;
  final SavedDesign? saved;

  CombinedPost({this.post, this.saved});

  bool get isPost => post != null;
}
