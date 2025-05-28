import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/theming/colors.dart';
import 'package:rommify_app/core/widgets/custom_chached_network_image.dart';
import 'package:rommify_app/core/widgets/custom_shimmer.dart';
import 'package:rommify_app/features/create_room_screen/logic/cubit/generate_cubit.dart';
import 'package:rommify_app/features/create_room_screen/logic/cubit/generate_staets.dart';

import '../../../core/widgets/custom_error.dart';
import '../../create_room_screen/ui/widget/circle_widget.dart';

class GenerateRoomScreen extends StatelessWidget {
  final GenerateCubit generateCubit;

  const GenerateRoomScreen({super.key, required this.generateCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: generateCubit,
      child: Scaffold(
        backgroundColor: ColorsManager.colorPrimary,
        body: BlocBuilder<GenerateCubit, GenerateStates>(
          builder: (BuildContext context, state) {
            return Stack(
              children: [
                CircleWidget(),
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
                        : generateCubit.generatedImagesResponse != null
                            ?  Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Column(
                                  children: [
                                    Expanded(
                                      child: GridView.builder(
                                        itemCount: generateCubit.generatedImagesResponse!.generatedImageUrls.length,
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2, // عمودين
                                          crossAxisSpacing: 12,
                                          mainAxisSpacing: 12,
                                          childAspectRatio: 1, // تخلي كل صورة مربعة
                                        ),
                                        itemBuilder: (context, index) {
                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: CustomCachedNetworkImage(imageUrl: generateCubit.generatedImagesResponse!.generatedImageUrls[index])
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // TODO: Add more functionality
                                          generateCubit.generateMore();
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
      ),
    );
  }
}
