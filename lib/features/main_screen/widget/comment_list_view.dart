import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/features/explore_screen/data/models/get_post_model.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/login_states.dart';
import 'package:rommify_app/features/main_screen/widget/comment_item.dart';

import '../../../core/helpers/constans.dart';
import '../../../core/helpers/shared_pref_helper.dart';
import '../../../core/widgets/custom_empity_list.dart';
import '../../../core/widgets/custom_error.dart';
import '../../../core/widgets/custom_shimmer.dart';
import '../../../core/widgets/flutter_show_toast.dart';
import '../../explore_screen/logic/cubit/posts_cubit.dart';

class CommentListView extends StatefulWidget {
  final String postId;
  const CommentListView({super.key, required this.postId});

  @override
  State<CommentListView> createState() => _CommentListViewState();
}

class _CommentListViewState extends State<CommentListView> {
  @override
  void initState() {
    // TODO: implement initState
    // PostsCubit.get(context).getComment(postId: widget.postId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostsCubit, PostsStates>(
      buildWhen: (previous, current) =>
      current is GetPostLoadingState ||
          context is GetPostErrorState ||
          current is GetPostSuccessState ||
          current is AddCommentSuccessState ||
          current is ChangeTimeState ||
          current is EditState ||
          current is UpdateCommentSuccessState ||
          current is DeleteCommentSuccessState,
      listenWhen: (previous, current) =>
          current is AddCommentLoadingState ||
          current is AddCommentErrorState ||
          current is AddCommentSuccessState ||
          current is UpdateCommentLoadingState ||
          current is UpdateCommentSuccessState ||
          current is UpdateCommentErrorState ||
          current is DeleteCommentLoadingState ||
          current is DeleteCommentSuccessState ||
          current is DeleteCommentErrorState,
      listener: (BuildContext context, state) {
        if (state is AddCommentLoadingState ||
            state is UpdateCommentLoadingState ||
            state is DeleteCommentLoadingState) {
          EasyLoading.show();
        } else if (state is AddCommentErrorState) {
          EasyLoading.dismiss();
          flutterShowToast(message: state.message, toastCase: ToastCase.error);
        } else if (state is UpdateCommentErrorState) {
          EasyLoading.dismiss();
          flutterShowToast(message: state.message, toastCase: ToastCase.error);
        } else if (state is DeleteCommentErrorState) {
          EasyLoading.dismiss();
          flutterShowToast(message: state.message, toastCase: ToastCase.error);
        } else if (state is AddCommentSuccessState) {
          EasyLoading.dismiss();
          flutterShowToast(
              message: "comment sent successfully",
              toastCase: ToastCase.success);
        } else if (state is UpdateCommentSuccessState) {
          EasyLoading.dismiss();
          flutterShowToast(
              message: "comment updated successfully",
              toastCase: ToastCase.success);
        } else if (state is DeleteCommentSuccessState) {
          EasyLoading.dismiss();
          flutterShowToast(
              message: state.deleteCommentResponse.message,
              toastCase: ToastCase.success);
        }
      },
      builder: (BuildContext context, state) {
        final comments = PostsCubit.get(context).getPostResponse?.postData.comments;
        return ListView.separated(
          shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (state is GetCommentLoadingState) {
                return const CustomShimmerEffect();
              }
              if (state is GetPostErrorState) {
                Center(
                  child: AnimatedErrorWidget(
                    title: "Loading Error",
                    message: state.message,
                    lottieAnimationPath: 'assets/animation/error.json',
                    // onRetry: _loadUserPosts,
                  ),
                );
              }
              if (comments == null || comments.isEmpty) {
                return const Center(
                  child: AnimatedEmptyList(
                    title: "No Comments Found",
                    subtitle:  "Start by creating your first Comment",
                    // : "",
                    // comments![index].userId ==
                    //                             SharedPrefHelper.getString(SharedPrefKey.userId)
                    //                         ?
                    lottieAnimationPath: 'assets/animation/empity_list.json',
                  ),
                );
              }
              return CommentItem(
                getCommentData:
                PostsCubit.get(context).getPostResponse!.postData.comments[index],
              );
            },
            separatorBuilder: (context, index) => SizedBox(
              height: 20.h,
            ),
            itemCount: comments?.length ?? 0);
      },
    );
  }
}
