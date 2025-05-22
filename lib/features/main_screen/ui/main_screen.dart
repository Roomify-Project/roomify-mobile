import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/helpers/constans.dart';
import 'package:rommify_app/core/theming/colors.dart';
import 'package:rommify_app/core/widgets/custom_error.dart';
import 'package:rommify_app/core/widgets/custom_shimmer.dart';
import 'package:rommify_app/core/widgets/flutter_show_toast.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/login_states.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/posts_cubit.dart';

import '../../../core/helpers/shared_pref_helper.dart';
import '../../../core/theming/styles.dart';
import '../../../core/widgets/custom_chached_network_image.dart';
import '../../create_room_screen/ui/widget/circle_widget.dart';
import '../widget/comment_list_view.dart';

class MainScreen extends StatefulWidget {
  final String postId;

  const MainScreen({super.key, required this.postId});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    // TODO: implement initState
    PostsCubit.get(context).getPost(postId: widget.postId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.colorPrimary,
      body: BlocConsumer<PostsCubit, PostsStates>(
        buildWhen: (previous, current) =>current is GetPostLoadingState||context is GetPostErrorState || current is GetPostSuccessState ,
        listenWhen: (previous, current) => current is DeletePostLoadingState||current is DeletePostErrorState || current is DeletePostSuccessState ,
        listener: (context, state) {
          if(state is DeletePostLoadingState){
            EasyLoading.show();
          }
          else if(state is DeletePostErrorState){
            EasyLoading.dismiss();
            flutterShowToast(message: state.message, toastCase: ToastCase.error);
          }
          else if(state is DeletePostSuccessState){
            EasyLoading.dismiss();
            flutterShowToast(message: state.message, toastCase: ToastCase.success);
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, state) {
          final postCubit = PostsCubit.get(context);
          if (state is GetPostLoadingState) {
            return const CustomShimmerEffect();
          } else if (state is GetPostErrorState) {
            return AnimatedErrorWidget(
              title: state.message,
            );
          }
          return Stack(
            children: [
              CircleWidget(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  SizedBox(height: 30.h,),
                  // Row(
                  //   children: [
                  //     Text(
                  //       "antoneos",
                  //       style: TextStyles.font12WhiteRegular
                  //           .copyWith(fontWeight: FontWeight.w700),
                  //     ),
                  //     Container(
                  //       width: 24.w,
                  //       height: 24.h,
                  //       decoration: const BoxDecoration(
                  //         shape: BoxShape.circle,
                  //       ),
                  //       child: ClipOval(child: CachedNetworkImage(imageUrl: postCubit.getPostResponse)),
                  //     )
                  //   ],
                  // ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding:  EdgeInsets.only(left: 16.w),
                      child: Text(postCubit.getPostResponse?.description??"",style: TextStyles.font18WhiteRegular,),
                    ),
                  ),
                  SizedBox(height: 20.h,),
                  Stack(
                      alignment: Alignment.topRight, children: [
                    Container(
                        width: double.infinity.w,
                        height: 300.h,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadiusDirectional.circular(14.r),
                        ),
                        child: CustomCachedNetworkImage(
                          imageUrl: postCubit.getPostResponse?.imagePath,
                          fit: BoxFit.cover,
                        )),
                  postCubit.getPostResponse!.applicationUserId==SharedPrefHelper.getString(SharedPrefKey.userId)?  PopupMenuButton(
                      color:const Color(0xFF2D1B2E),
                      icon: const Icon(Icons.more_vert), // أيقونة النقاط الثلاث
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.white), // أيقونة الحذف
                              SizedBox(width: 8), // مسافة بين الأيقونة والنص
                              Text('Delete Post', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'delete') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor:  const Color(0xFF2D1B2E),
                                title:  Text('Delete Post',style: TextStyles.font18WhiteRegular,),
                                content:  Text('Are you sure you want to delete this post?',style: TextStyles.font16WhiteInter),
                                actions: [
                                  TextButton(
                                    child:  const Text('Cancel',style: TextStyle(color: Colors.white),),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      postCubit.deletePost(postId: widget.postId);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ):const SizedBox(),
                  ]),
                  SizedBox(
                    height: 29.h,
                  ),
                   Expanded(child: CommentListView(postId: widget.postId,)),
                  SizedBox(height: 10.h,),
                  Container(
                    width: 376.w,
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
                        hintText: "Comment.....",
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                        suffixIcon: InkWell(
                          onTap: () {
                            postCubit.addComment(postId: widget.postId);
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.white.withOpacity(0.7),
                            size: 24.w,
                          ),
                        ),
                      ),
                      cursorColor: Colors.white,
                    ),
                  ),
                  // const Spacer(),

                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),

            ],
          );
        },
      ),
    );
  }
}
