import 'package:easy_localization/easy_localization.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rommify_app/core/helpers/constans.dart';
import 'package:rommify_app/core/helpers/extensions.dart';
import 'package:rommify_app/core/theming/colors.dart';
import 'package:rommify_app/core/widgets/custom_error.dart';
import 'package:rommify_app/core/widgets/custom_shimmer.dart';
import 'package:rommify_app/core/widgets/flutter_show_toast.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/login_states.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/posts_cubit.dart';

import '../../../core/helpers/shared_pref_helper.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theming/styles.dart';
import '../../../core/widgets/custom_chached_network_image.dart';
import '../../create_room_screen/ui/widget/circle_widget.dart';
import '../widget/comment_list_view.dart';

class MainScreen extends StatefulWidget {
  final String postId;
  final bool? isPost;

  const MainScreen({super.key, required this.postId, this.isPost});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    PostsCubit.get(context).getPost(postId: widget.postId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostsCubit, PostsStates>(
      buildWhen: (previous, current) =>
      current is GetPostLoadingState ||
          current is GetPostErrorState ||
          current is AddCommentSuccessState||
          current is GetPostSuccessState ||
          current is ChangeEmojiState||
      current is AddLikeSuccessState,
      listenWhen: (previous, current) =>
      current is DeletePostLoadingState ||
          current is DeletePostErrorState ||
          current is DeletePostSuccessState,
      listener: (context, state) {
        if (state is DeletePostLoadingState) {
          EasyLoading.show();
        } else if (state is DeletePostErrorState) {
          EasyLoading.dismiss();
          flutterShowToast(message: state.message, toastCase: ToastCase.error);
        } else if (state is DeletePostSuccessState) {
          EasyLoading.dismiss();
          flutterShowToast(
              message: state.message, toastCase: ToastCase.success);
          Navigator.pop(context);
        }
      },
      builder: (BuildContext context, state) {
        final postCubit = PostsCubit.get(context);
        if (state is GetPostLoadingState) {
          return Scaffold(
              backgroundColor: ColorsManager.colorPrimary,
              body: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50.h),
                    child: const CustomShimmerEffect(),
                  )));
        } else if (state is GetPostErrorState) {
          return AnimatedErrorWidget(
            title: state.message,
          );
        }
        return Scaffold(
          backgroundColor: ColorsManager.colorPrimary,
          resizeToAvoidBottomInset: true,
          body: WillPopScope(
            onWillPop: () async {
              if (postCubit.emojiShowing) {
                postCubit.changeEmojiState();
                return false;
              }
              return true;
            },
            child: Column(
              children: [
                // المحتوى الأساسي
                Expanded(
                  child: Stack(
                    children: [
                      // CircleWidget(),
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 20.h),
                            SizedBox(height: 30.h),
                            InkWell(
                              onTap: () {
                                context.pushNamed(Routes.profile, arguments: {
                                  'profileId':
                                  postCubit.getPostResponse!.postData.userId
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.w),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50.w,
                                      height: 50.h,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: ClipOval(
                                          child: CustomCachedNetworkImage(
                                            imageUrl: postCubit.getPostResponse!
                                                .postData.userProfilePicture ??
                                                "",
                                            fit: BoxFit.cover,
                                            isDefault: true,
                                          )),
                                    ),
                                    SizedBox(width: 16.w),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          postCubit.getPostResponse!.postData
                                              .userName ??
                                              "",
                                          style: TextStyles.font18WhiteRegular
                                              .copyWith(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          postCubit.timeMap[postCubit
                                              .getPostResponse!
                                              .postData
                                              .id] ??
                                              "",
                                          style: TextStyles.font12WhiteRegular
                                              .copyWith(
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    postCubit.getPostResponse!.postData
                                        .userId ==
                                        SharedPrefHelper.getString(
                                            SharedPrefKey.userId)
                                        ? PopupMenuButton(
                                      color: const Color(0xFF2D1B2E),
                                      icon: const Icon(Icons.more_vert,
                                          color: Colors.white),
                                      itemBuilder: (context) => [
                                         PopupMenuItem(
                                          value: 'delete'.tr(),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.delete,
                                                  color: Colors.white),
                                              SizedBox(width: 8.w),
                                              Text('Delete Post'.tr(),
                                                  style: const TextStyle(
                                                      color:
                                                      Colors.white)),
                                            ],
                                          ),
                                        ),
                                      ],
                                      onSelected: (value) {
                                        if (value == 'delete') {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor:
                                                const Color(
                                                    0xFF2D1B2E),
                                                title: Text(
                                                  'Delete Post'.tr(),
                                                  style: TextStyles
                                                      .font18WhiteRegular,
                                                ),
                                                content: Text(
                                                    'Are you sure you want to delete this post?'.tr(),
                                                    style: TextStyles
                                                        .font16WhiteInter),
                                                actions: [
                                                  TextButton(
                                                    child:  Text(
                                                      'Cancel'.tr(),
                                                      style: const TextStyle(
                                                          color: Colors
                                                              .white),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(
                                                          context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child:  Text(
                                                        'Delete'.tr(),
                                                        style: const TextStyle(
                                                            color: Colors
                                                                .red)),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context);
                                                      postCubit.deletePost(
                                                          postId: widget
                                                              .postId);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                    )
                                        : const SizedBox(),
                                    SizedBox(width: 16.w)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 30.h),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 16.w),
                                child: Text(
                                  postCubit.getPostResponse!.postData
                                      .description ??
                                      "",
                                  style: TextStyles.font18WhiteRegular,
                                ),
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Stack(alignment: Alignment.topRight, children: [
                              Container(
                                  width: double.infinity.w,
                                  height: 300.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:
                                    BorderRadiusDirectional.circular(14.r),
                                  ),
                                  child: CustomCachedNetworkImage(
                                    imageUrl: postCubit
                                        .getPostResponse!.postData.imagePath,
                                    fit: BoxFit.fill,
                                  )),
                            ]),
                            Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10.h,),
                                  // قسم الإحصائيات
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // عدد اللايكات
                                      Row(
                                        children: [
                                          InkWell(

                                            child: Icon(
                                              Icons.favorite,
                                              color: Colors.white,
                                              size: 20.sp,
                                            ),
                                            onTap: () {
                                              true? postCubit.addLike(
                                                  postId: postCubit.getPostResponse!.postData.id,
                                                  isPost: postCubit.getPostResponse!.type=='Post',
                                                  recieverId: postCubit.getPostResponse!.postData.userId
                                              ):postCubit.removeLike(
                                                  postId: postCubit.getPostResponse!.postData.id,
                                                  isPost: postCubit.getPostResponse!.type=='Post',
                                                  recieverId: postCubit.getPostResponse!.postData.userId
                                              );
                                            },
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            "${postCubit.getPostResponse!.postData.likesCount} likes".tr(),
                                            style: TextStyles.font14WhiteRegular,
                                          ),
                                        ],
                                      ),
                                      // عدد التعليقات
                                      Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.comment,
                                            color: Colors.white,
                                            size: 20.sp,
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            "${postCubit.getPostResponse!.postData.comments.length ?? 0} comments".tr(),
                                            style: TextStyles.font14WhiteRegular,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            CommentListView(postId: widget.postId),
                            SizedBox(height: 30.h), // مساحة إضافية للكومنت بار
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 16.h, horizontal: 5.w),
                      child: Container(
                        width: double.infinity.w,
                        height: 84.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFA9631D).withOpacity(0.29),
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFA9631D).withOpacity(0.25),
                              blurRadius: 25,
                              spreadRadius: 0,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        alignment: Alignment.center,
                        child: TextFormField(
                          controller: postCubit.commentController,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16.sp,
                          ),
                          decoration: InputDecoration(
                            hintText: "Comment.....".tr(),
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    postCubit.changeEmojiState();
                                  },
                                  child: Icon(
                                    postCubit.emojiShowing
                                        ? Icons.keyboard
                                        : Icons.emoji_emotions_outlined,
                                    color: Colors.white,
                                    size: 24.sp,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                InkWell(
                                  onTap: () {
                                    postCubit.addComment(
                                        postId: widget.postId,
                                        recieverId: postCubit.getPostResponse!
                                            .postData.userId ??
                                            "",
                                        isPost: widget.isPost ?? true);
                                  },
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white.withOpacity(0.7),
                                    size: 24.w,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          cursorColor: Colors.white,
                        ),
                      ),
                    ),

                    // الإيموجي بيكر
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: postCubit.emojiShowing ? 300 : 0,
                      child: postCubit.emojiShowing
                          ? EmojiPicker(
                        textEditingController:
                        postCubit.commentController,
                        config: Config(
                          height: 300,
                          checkPlatformCompatibility: true,
                          emojiViewConfig: const EmojiViewConfig(
                            backgroundColor: ColorsManager.colorPrimary,
                            columns: 7,
                            emojiSizeMax: 28,
                            verticalSpacing: 2,
                            horizontalSpacing: 2,
                            gridPadding: EdgeInsets.all(4),
                            buttonMode: ButtonMode.MATERIAL,
                            loadingIndicator: Center(
                              child: CircularProgressIndicator(
                                color: ColorsManager.colorSecondry,
                                strokeWidth: 2,
                              ),
                            ),
                            recentsLimit: 28,
                            replaceEmojiOnLimitExceed: true,
                          ),
                          skinToneConfig: const SkinToneConfig(
                            indicatorColor: ColorsManager.colorSecondry,
                            dialogBackgroundColor:
                            ColorsManager.colorSecondry,
                            enabled: true,
                          ),
                          categoryViewConfig: CategoryViewConfig(
                            indicatorColor: ColorsManager.colorSecondry,
                            iconColorSelected:
                            ColorsManager.colorSecondry,
                            backgroundColor: ColorsManager.colorPrimary,
                            iconColor: Colors.grey,
                            tabIndicatorAnimDuration:
                            Duration(milliseconds: 200),
                            dividerColor: Colors.grey.shade300,
                            recentTabBehavior: RecentTabBehavior.RECENT,
                          ),
                          bottomActionBarConfig:
                          const BottomActionBarConfig(
                            backgroundColor: ColorsManager.colorSecondry,
                            buttonColor: Colors.white,
                            buttonIconColor: ColorsManager.white,
                            showBackspaceButton: false,
                            showSearchViewButton: false,
                          ),
                          searchViewConfig:  SearchViewConfig(
                            backgroundColor: ColorsManager.colorPrimary,
                            buttonIconColor: Colors.white,
                            hintText: 'Search emoji...'.tr(),
                          ),
                        ),
                      )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
