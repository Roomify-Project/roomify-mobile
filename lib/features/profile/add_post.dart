import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/theming/colors.dart';
import 'package:rommify_app/core/theming/styles.dart';
import 'package:rommify_app/core/widgets/flutter_show_toast.dart';
import 'package:rommify_app/features/create_room_screen/ui/widget/circle_widget.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/login_states.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/posts_cubit.dart';

import '../../core/helpers/constans.dart';
import '../../core/helpers/shared_pref_helper.dart';

class AddPostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.colorPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        title: Text(
          'Add Post',
          style: TextStyles.font18WhiteRegular,
        ),
        centerTitle: true,
      ),
      body: 
          BlocConsumer<PostsCubit, PostsStates>(
            listener: (BuildContext context, PostsStates state) {
              if(state is AddPostLoadingState){
                EasyLoading.show();
              }
              else if(state is AddPostSuccessState){
                flutterShowToast(message: state.addPostResponse.message, toastCase: ToastCase.success);
                EasyLoading.dismiss();
              }
              else if(state is AddPostErrorState){
                flutterShowToast(message:state.message, toastCase: ToastCase.success);
                EasyLoading.dismiss();

              }
            },
            builder: (BuildContext context, state) {
              final postCubit = PostsCubit.get(context);
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          postCubit.pickImageFromGallery();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 80.h,
                            ),
                            const Center(
                              child: Text(
                                'Add Image',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            postCubit.imageFile == null
                                ? Container(
                              width: double.infinity,
                              height: 150.h,
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(Icons.add,
                                  color: Colors.white, size: 50.sp),
                            )
                                : Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 200.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius:
                                    BorderRadius.circular(12.r),
                                  ),
                                  child: Image.file(postCubit.imageFile!,
                                      fit: BoxFit.fill),
                                ),
                
                                Container(
                                  width: 24.w,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      postCubit.clearImage();
                                    },
                                    child: const Center(
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32.h),
                      TextField(
                        maxLines: 5,
                        controller: postCubit.addPostTextController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Write your post here...',
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.white24,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                      ElevatedButton(
                        onPressed: () {
                          // Add post functionality here
                          postCubit.addPost(userId:SharedPrefHelper.getString(SharedPrefKey.userId));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D1B2E),
                          padding: EdgeInsets.symmetric(
                              horizontal: 140.w, vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                        ),
                        child: Text(
                          'Post',
                          style: TextStyles.font16WhiteInter,
                        ),
                      ),
                    ],
                  ),
                ),
              );

            },
          ),
       
    );
  }
}
