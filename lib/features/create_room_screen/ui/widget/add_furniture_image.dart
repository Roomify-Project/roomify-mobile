import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/colors.dart';
import 'add_furniture_dialog.dart';

class AddFurnitureImage extends StatelessWidget {
  const AddFurnitureImage({super.key});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AddFurniturImage(),
        );
      },
      child: Container(
          width: double.infinity,
          height: 67.h,
          decoration: BoxDecoration(
            color: ColorsManager.colorContainer,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(24.r),
              bottomLeft: Radius.circular(24.r),
            ),
            // Transparent background
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 35.w,
                height: 35.h,
                decoration:  BoxDecoration(
                    color: ColorsManager.colorContainer,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorsManager.colorCircle,
                      width: 3,
                    )
                ),
                child: const Icon(Icons.add,color: ColorsManager.colorIcon,),
              ),
              Text("Add furniture images",style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w400,color: Colors.white),)
            ],
          )
      ),
    );
  }
}
