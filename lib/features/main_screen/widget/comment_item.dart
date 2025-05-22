import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/widgets/custom_chached_network_image.dart';
import 'package:rommify_app/features/explore_screen/data/models/get_omment_model.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/posts_cubit.dart';

import '../../../core/helpers/constans.dart';
import '../../../core/theming/styles.dart';

class CommentItem extends StatefulWidget {

  final CommentData getCommentData;
  const CommentItem({super.key, required this.getCommentData});

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  @override
  void initState() {
    // TODO: implement initState
    PostsCubit.get(context).getElapsedTime(widget.getCommentData.createdAt, widget.getCommentData.id);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print("iddd ${PostsCubit.get(context).timeMap[widget.getCommentData.id]}");
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 25.r,
                    child: ClipOval(child: CustomCachedNetworkImage(imageUrl: widget.getCommentData.userProfilePicture??Constants.defaultImagePerson)),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // width: 267.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFF767676).withOpacity(0.29),
                          // تم إضافة شفافية 29%
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF767676).withOpacity(0.25),
                              // تم تعديل لون الظل
                              blurRadius: 25,
                              spreadRadius: 0,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        // padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Padding(
                          padding:  EdgeInsets.only(right: 48.w,top: 10.h,bottom: 16.h,left: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SizedBox(height: 10.h,),
                              Text(
                                widget.getCommentData.userName,
                                style: TextStyles.font12WhiteRegular
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                              // SizedBox(height: 16.h,),
                              Text(
                                widget.getCommentData.content, // النص من الصورة
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h,),
                      Text(
                        PostsCubit.get(context).timeMap[widget.getCommentData.id]??"",
                        style: TextStyles.font12GreyLight,
                      )

                    ],
                  ),
                  // const Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     // Text(
                  //     //   "Interior Designer",
                  //     //   style: TextStyles.font12WhiteRegular.copyWith(
                  //     //       fontWeight: FontWeight.w400, fontSize: 10),
                  //     // ),
                  //     // Text(
                  //     //   "@aliellebi123",
                  //     //   style: TextStyles.font12WhiteRegular.copyWith(
                  //     //       fontWeight: FontWeight.w400, fontSize: 8),
                  //     // ),
                  //   ],
                  // ),
                ],
              ),

            ],
          ),
        ),
        // SizedBox(
        //   height: 5.h,
        // ),
      ],
    );
  }
}
