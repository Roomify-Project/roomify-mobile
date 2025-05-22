import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    PostsCubit.get(context).getComment(postId: widget.postId);

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostsCubit,PostsStates>(
      buildWhen: (previous, current) => current is GetCommentSuccessState||current is GetCommentErrorState||current is GetCommentLoadingState|| current is AddCommentSuccessState||current is ChangeTimeState,
      listenWhen: (previous, current) => current is AddCommentLoadingState || current is AddCommentErrorState ||  current is AddCommentSuccessState,
      listener: (BuildContext context, state) {
        if(state is AddCommentLoadingState){
          EasyLoading.show();
        }
        else if(state is AddCommentErrorState){
          EasyLoading.dismiss();
          flutterShowToast(message: state.message, toastCase: ToastCase.error);
        }
        else if(state is AddCommentSuccessState){
          EasyLoading.dismiss();
          flutterShowToast(message: "comment sent successfully", toastCase: ToastCase.success);

        }
      },
      builder: (BuildContext context, state) {
        final comments=PostsCubit.get(context).getCommentResponse?.comments;
        return ListView.separated(
            itemBuilder: (context, index) {
              if (state is GetCommentLoadingState) {
                return const CustomShimmerEffect();
              }
              if(state is GetCommentErrorState){
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
                return  Center(
                  child: AnimatedEmptyList(
                    title: "No Posts Found",
                    subtitle: comments![index].userId==SharedPrefHelper.getString(SharedPrefKey.userId)?"Start by creating your first Comment":"",
                    lottieAnimationPath: 'assets/animation/empity_list.json',
                  ),
                );
              }
              return  CommentItem(getCommentData:PostsCubit.get(context).getCommentResponse!.comments[index],);
            },
            separatorBuilder: (context, index) => SizedBox(
              height: 20.h,
            ),
            itemCount: comments?.length??0);
      },

    );
  }
}
