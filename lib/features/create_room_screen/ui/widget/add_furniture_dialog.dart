import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rommify_app/features/create_room_screen/ui/widget/unit_drop_down_widget.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/font_weight_helper.dart';
import '../../../../core/theming/styles.dart';
import 'custom_room_sizes_text_Form.dart';

class AddFurniturImage extends StatefulWidget {
  @override
  _AddFurniturImageState createState() => _AddFurniturImageState();
}

class _AddFurniturImageState extends State<AddFurniturImage> {
  String selectedUnit = 'meter';
  TextEditingController lengthController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 613.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsManager.colorDialog,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding:  EdgeInsets.only(left: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 17.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Upload room images'.tr(),
                      style: TextStyles.font16WhiteInter),
                  SizedBox(height: 9.h),
                  Text(
                    'Upload one or maximum two images for your room.\nAnd enter its 3 dimensions values.'.tr(),
                    style: TextStyles.font14WhiteRegular
                        .copyWith(fontWeight: FontWeightHelper.regular),
                  ),
                ],
              ),
              SizedBox(height: 37.h),
              // Room dimensions input section
              Row(
                children: [
                  Container(
                    width: 123.w,
                    height: 109.h,
                    decoration: BoxDecoration(
                      color: ColorsManager.colorContainer,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.r),
                        bottomLeft: Radius.circular(24.r),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/room_image_icon.svg',
                          width: 33.w,
                          height: 36.h,
                          color: Colors.white,
                        ),
                        SizedBox(height: 6.h),
                         Text(
                          'room image'.tr(),
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 8.w,
                        ),
                        SizedBox(
                          height: 109.h,
                          child: Column(
                            children: [
                              // Length field
                              const CustomRoomSizesTextForm(),
                              SizedBox(height: 8.h),
                              // Width field
                              const CustomRoomSizesTextForm(),
                              SizedBox(height: 8.h),
                              const CustomRoomSizesTextForm(),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        UnitDropdown(),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 40.h,
              ),
              Row(
                children: [
                  Container(
                    width: 51.w,
                    height: 51.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorsManager.colorLightGrey2,
                    ),
                    child: Icon(
                      Icons.add,
                      color: ColorsManager.colorIcon,
                      size: 40.sp,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    "Add last one".tr(),
                    style: TextStyles.font14WhiteRegular
                        .copyWith(fontWeight: FontWeight.w700),
                  )
                ],
              ),
              SizedBox(
                height: 190.h,
              ),
              Center(
                child: SizedBox(
                  height: 45.h,
                  width: 102.w,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle save action here
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding:EdgeInsets.zero
                    ),
                    child: Text('Save'.tr(),
                        style: TextStyles.font24WhiteExtraBold.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorsManager.colorDeepBurble)),
                  ),
                ),
              ),
              SizedBox(height: 30.h,)
            ],
          ),
        ),
      ),
    );
  }
}
