import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/helpers/extensions.dart';
import 'package:rommify_app/core/helpers/shared_pref_helper.dart';
import 'package:rommify_app/core/widgets/custom_chached_network_image.dart';
import 'package:rommify_app/features/explore_screen/data/models/get_omment_model.dart';
import 'package:rommify_app/features/explore_screen/data/models/get_post_model.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/posts_cubit.dart';
import 'package:rommify_app/features/main_screen/widget/show_update_dialog.dart';

import '../../../core/helpers/constans.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theming/styles.dart';

class CommentItem extends StatefulWidget {
  final CommentModel getCommentData;

  const CommentItem({super.key, required this.getCommentData});

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PostsCubit.get(context).getElapsedTime(
        widget.getCommentData.createdAt,
        widget.getCommentData.id,
      );

      PostsCubit.get(context).focusNode = FocusNode();
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final postCubit = PostsCubit.get(context);
    print("iddd ${postCubit.timeMap[widget.getCommentData.id]}");
    return InkWell(
      onTap: () {
        context.pushNamed(Routes.profile,arguments: {'profileId':widget.getCommentData.userId});

      },
      child: Column(
        children: [

          Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        context.pushNamed(Routes.profile,arguments: {'profileId':widget.getCommentData.userId});

                      },
                      child: CircleAvatar(
                        radius: 25.r,
                        // radius: postCubit.isEditingMap[widget.getCommentData.id]??false ? 18.r : 25.r,
                        child: ClipOval(
                          child: CustomCachedNetworkImage(
                            isZoom: false,
                            height: double.infinity,
                            width: double.infinity,
                            imageUrl: widget.getCommentData.userProfilePicture??
                                Constants.defaultImagePerson,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: postCubit.isEditingMap[widget.getCommentData.id]??false ? 8.w : 10.w),
                    // تقليل المسافة أثناء التعديل
                    Expanded(
                      child: GestureDetector(
                        onLongPress: () async {
                          if(await SharedPrefHelper.getString(SharedPrefKey.userId)==widget.getCommentData.userId) {
                            showOptionsBottomSheet(postCubit: postCubit,
                                context: context,
                                commentId: widget.getCommentData.id);
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                color: const Color(0xFF767676).withOpacity(0.29),
                                borderRadius: BorderRadius.circular(24.r),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color(0xFF767676).withOpacity(0.25),
                                    blurRadius: 25,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: postCubit.isEditingMap[widget.getCommentData.id]??false ? 16.w : 48.w,
                                  // تقليل الـ padding أثناء التعديل
                                  top: 10.h,
                                  bottom: 16.h,
                                  left: 16.w,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.getCommentData.userName,
                                      style:
                                          TextStyles.font12WhiteRegular.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    if (postCubit.isEditingMap[widget.getCommentData.id]??false) ...[
                                      TextFormField(
                                        controller: postCubit.updateCommentController=TextEditingController(text: widget.getCommentData.content)
                                        ,
                                        focusNode: postCubit.focusNode,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                        maxLines: null,
                                        onFieldSubmitted: (_) => {
                                        postCubit.updateComment(
                                        commentId:
                                        widget.getCommentData.id)
                                        },
                                      ),
                                      SizedBox(height: 8.h),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap:() {
                                              postCubit.updateComment(
                                                  commentId:
                                                      widget.getCommentData.id);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                                vertical: 4.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                              ),
                                              child: Text(
                                                'Save',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          GestureDetector(
                                            onTap: (){
                                              postCubit.cancelEdit(commentId: widget.getCommentData.id);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                                vertical: 4.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color:
                                                    Colors.grey.withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                              ),
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ] else ...[
                                      Text(
                                        widget.getCommentData.content,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              PostsCubit.get(context)
                                      .timeMap[widget.getCommentData.id] ??
                                  "",
                              style: TextStyles.font12GreyLight,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
