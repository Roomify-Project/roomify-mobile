import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/features/create_room_screen/ui/widget/upload_room_dialog.dart';
import '../../../../core/theming/colors.dart';

class AddRoomImage extends StatelessWidget {
  const AddRoomImage({super.key});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => UploadRoomDialog(),
        );
      },
      child: Container(
          width: double.infinity,
          height: 67.h,
          decoration: BoxDecoration(
            color: ColorsManager.colorContainer,
            // Transparent background
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
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
                    )),
                child: const Icon(
                  Icons.add,
                  color: ColorsManager.colorIcon,
                ),
              ),
              Text(
                "Add room images",
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              )
            ],
          )),
    );
  }
}


