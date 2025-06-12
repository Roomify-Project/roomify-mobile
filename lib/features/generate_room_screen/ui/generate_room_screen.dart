import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/theming/colors.dart';
import 'package:rommify_app/core/widgets/custom_chached_network_image.dart';
import 'package:rommify_app/core/widgets/custom_shimmer.dart';
import 'package:rommify_app/features/create_room_screen/logic/cubit/generate_cubit.dart';
import 'package:rommify_app/features/create_room_screen/logic/cubit/generate_staets.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/login_states.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/posts_cubit.dart';
import 'package:rommify_app/features/profile/profile.dart';

import '../../../core/widgets/custom_error.dart';
import '../../create_room_screen/ui/widget/circle_widget.dart';

class GenerateRoomScreen extends StatefulWidget {
  final GenerateCubit generateCubit;

  const GenerateRoomScreen({super.key, required this.generateCubit});

  @override
  State<GenerateRoomScreen> createState() => _GenerateRoomScreenState();
}

class _GenerateRoomScreenState extends State<GenerateRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.generateCubit,
      child: BlocBuilder<PostsCubit,PostsStates>(
        builder: (BuildContext context, state) { 
          return Scaffold(
            backgroundColor: ColorsManager.colorPrimary,
            body: BlocBuilder<GenerateCubit, GenerateStates>(
              builder: (BuildContext context, state) {
                final generateCubitItem=GenerateCubit.get(context);
                return Stack(
                  children: [
                    // CircleWidget(),
                    state is GenerateLoadingState
                        ? Padding(
                      padding: EdgeInsets.only(top: 50.h),
                      child: const CustomShimmerEffect(),
                    )
                        : state is GenerateErrorState
                        ? Center(
                      child: AnimatedErrorWidget(
                        title: "Loading Error",
                        message: state.message ?? "No data available",
                        lottieAnimationPath:
                        'assets/animation/error.json',
                      ),
                    )
                        : generateCubitItem.generatedImagesResponse != null
                        ? Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:  EdgeInsets.only(left: 23.w,right: 23.w),
                              child: GridView.builder(
                                itemCount: generateCubitItem.generatedImagesResponse!
                                    .generatedImageUrls.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 15,
                                    childAspectRatio: 169 / 128,
                                ),
                                itemBuilder: (context, index) {
                                  return ImageCard(
                                    isZoom: true,
                                      imageUrl: generateCubitItem.generatedImagesResponse!.generatedImageUrls[index],
                                      profileImageUrl: '',
                                      isSave: true,
                                      isProfile: false,
                                      onExpand: () {
                                        setState(() {
                                          generateCubitItem.isExpandedList[index] = !generateCubitItem.isExpandedList[index];
                                          // print(postsCubit.isExpandedList[index]);
                                        });
                                      },
                                      isExpanded:generateCubitItem.isExpandedList[index],

                                      postsCubit: PostsCubit.get(context)
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Add more functionality
                                widget.generateCubit.generateMore();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Text(
                                'More',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                        : const SizedBox(),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
