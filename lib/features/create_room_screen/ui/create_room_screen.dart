import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/helpers/extensions.dart';
import 'package:rommify_app/core/theming/colors.dart';
import 'package:rommify_app/core/widgets/flutter_show_toast.dart';
import 'package:rommify_app/features/create_room_screen/data/repos/generate_repo.dart';
import 'package:rommify_app/features/create_room_screen/logic/cubit/generate_cubit.dart';
import 'package:rommify_app/features/create_room_screen/logic/cubit/generate_staets.dart';
import 'package:rommify_app/features/create_room_screen/ui/widget/add_furniture_image.dart';
import 'package:rommify_app/features/create_room_screen/ui/widget/add_room_Image.dart';
import 'package:rommify_app/features/create_room_screen/ui/widget/circle_widget.dart';
import 'package:rommify_app/features/create_room_screen/ui/widget/design_style.dart';
import 'package:rommify_app/features/create_room_screen/ui/widget/room_type.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theming/styles.dart';

class CreateRoomScreen extends StatelessWidget {
  const CreateRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>GenerateCubit(getIt.get<GenerateRepo>()),
      child: BlocConsumer<GenerateCubit,GenerateStates>(
        listener: (BuildContext context, GenerateStates state) {
          if(state is GenerateValidationErrorState){
            flutterShowToast(message: state.message, toastCase: ToastCase.error);
          }
        },
        builder: (BuildContext context, state) {
          final generateCubit=GenerateCubit.get(context);
          return  Scaffold(
              backgroundColor: ColorsManager.colorPrimary,
              body: Stack(
                children: [
                  CircleWidget(),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60.h,
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    color: ColorsManager.colorContainer,
                                    // Transparent background
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.r),
                                        topRight:
                                        Radius.circular(20.r)), // Rounded corners
                                  ),
                                  child: TextFormField(
                                    controller:generateCubit.generateController,
                                    style: TextStyles.font14WhiteRegular.copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: null, // يسمح بكتابة أكثر من سطر
                                    decoration: InputDecoration(
                                      hintText:"write description",
                                      // "Put this wall clock on the wall of room \n image above the sofa, fit it with light and \n shadow of room image",
                                      hintStyle:
                                      TextStyles.font14WhiteRegular.copyWith(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      filled: false,
                                      fillColor: ColorsManager.colorContainer,
                                      // نفس لون الخلفية
                                      contentPadding: EdgeInsets.only(
                                          top: 20.h, left: 8.w, right: 8.w),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.r),
                                          topRight: Radius.circular(20.r),
                                        ),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                                 AddRoomImage(generateCubit: generateCubit,),
                                SizedBox(
                                  height: 3.h,
                                ),
                                // const AddFurnitureImage(),
                                SizedBox(
                                  height: 65.h,
                                ),
                                InkWell(
                                  child: Text("Room type",
                                      style: TextStyles.font15WhiteRegular
                                          .copyWith(fontSize: 16.sp)),
                                  onTap: () {
                                    context.pushNamed(Routes.exploreScreen);
                                  },
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                                 RoomType(generateCubit: generateCubit,),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Text("Style",
                                    style: TextStyles.font15WhiteRegular
                                        .copyWith(fontSize: 16.sp)),
                                SizedBox(
                                  height: 3.h,
                                ),
                                 DesignStyle(generateCubit: generateCubit,),
                                SizedBox(
                                  height: 50.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              generateCubit.generate(context: context);
                              print("Purple button pressed!");

                              // Define what happens when the button is pressed
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsManager.mainBurble,
                              // Set the button color to purple
                              padding: EdgeInsets.symmetric(
                                  horizontal: 100.w, vertical: 15.h),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(32), // Rounded corners
                              ),
                            ),
                            child: Text('GENERATE',
                                style: TextStyles.font21BlackSemiBold
                                    .copyWith(color: Colors.white, fontSize: 18.sp)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ));
        },

      ),
    );
  }
}
