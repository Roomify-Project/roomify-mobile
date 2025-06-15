import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/widgets/custom_chached_network_image.dart';
import 'package:rommify_app/features/create_room_screen/logic/cubit/generate_cubit.dart';
import 'package:rommify_app/features/create_room_screen/ui/widget/upload_room_dialog.dart';
import '../../../../core/theming/colors.dart';

class AddRoomImage extends StatelessWidget {
  final GenerateCubit generateCubit;
  const AddRoomImage({super.key, required this.generateCubit});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) =>  UploadRoomDialog(generateCubit: generateCubit,),
        );
      },
      child: Container(
          width: double.infinity,
          height: 67.h,
          decoration: BoxDecoration(
            color: ColorsManager.colorContainer,
            // Transparent background
          ),
          child: Row(
            children: [
              // الجزء الخاص بالصورة – محاذي لليسار
              if (generateCubit.imageFile != null)
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 80.w,
                      height: 90.h,
                      decoration: BoxDecoration(
                        color: ColorsManager.colorContainer,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(8.r),
                          bottomLeft: Radius.circular(12.r),
                          topRight: Radius.circular(8.r),
                        ),
                      ),
                      child: Image.file(
                        generateCubit.imageFile!,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                )
              else
                const Spacer(), // لو مفيش صورة خليه يسيب مساحة فاضية

              // الجزء الخاص بزر الإضافة – في منتصف الـ Row
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 35.w,
                        height: 35.h,
                        decoration: BoxDecoration(
                          color: ColorsManager.colorContainer,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ColorsManager.colorCircle,
                            width: 3,
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: ColorsManager.colorIcon,
                        ),
                      ),
                      Text(
                        "Add room images".tr(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
            ],
          )

      ),
    );
  }
}


