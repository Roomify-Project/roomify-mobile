import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/theming/colors.dart';
import 'package:rommify_app/core/widgets/custom_error.dart';
import 'package:rommify_app/core/widgets/custom_shimmer.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/login_states.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/posts_cubit.dart';

import '../../../core/theming/styles.dart';
import '../../../core/widgets/custom_chached_network_image.dart';
import '../../create_room_screen/ui/widget/circle_widget.dart';

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
      body: BlocBuilder<PostsCubit,PostsStates>(
        builder: (BuildContext context, state) {
          final postCubit=PostsCubit.get(context);
          if(state is GetPostLoadingState){
            return const CustomShimmerEffect();
          }
          else if (state is GetPostErrorState){
            return  AnimatedErrorWidget(title: state.message,);
          }
          return Stack(
            children: [
              CircleWidget(),
              Column(
                children: [
                  SizedBox(
                    height: 60.h,
                  ),
                  Container(
                    width: double.infinity.w,
                    height: 300.h,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadiusDirectional.circular(14.r),
                    ),
                    child: CustomCachedNetworkImage(imageUrl: postCubit.getPostResponse?.imagePath,)
                  ),
                  SizedBox(
                    height: 29.h,
                  ),
                  Padding(
                    padding:  EdgeInsets.only(left: 47.w),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30.r,
                          backgroundImage: const NetworkImage(
                              'https://th.bing.com/th/id/OIP.9nl2eFOD4SKNC_FIn0bSqQHaFj?rs=1&pid=ImgDetMain'),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "antoneos",
                              style: TextStyles.font12WhiteRegular.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              "Interior Designer",
                              style: TextStyles.font12WhiteRegular.copyWith(fontWeight: FontWeight.w400,fontSize: 10),
                            ),
                            Text(
                              "@aliellebi123",
                              style: TextStyles.font12WhiteRegular.copyWith(fontWeight: FontWeight.w400,fontSize: 8),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  Container(
                    width: 267.w, // تم تعديل العرض ليطابق الصورة
                    height: 67.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF767676).withOpacity(0.29), // تم إضافة شفافية 29%
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF767676).withOpacity(0.25), // تم تعديل لون الظل
                          blurRadius: 25,
                          spreadRadius: 0,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Center(
                      child: Text(
                        "ارحم وسيب حاجة ليي بعدك 🔥",  // النص من الصورة
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 376.w,
                    height: 84.h, // تم تعديل الارتفاع ليطابق الصورة
                    decoration: BoxDecoration(
                      color: const Color(0xFFA9631D).withOpacity(0.29), // تم إضافة شفافية 29%
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Comment.....",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Icon(
                          Icons.send,
                          color: Colors.white.withOpacity(0.7),
                          size: 24.w,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h,),

                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
