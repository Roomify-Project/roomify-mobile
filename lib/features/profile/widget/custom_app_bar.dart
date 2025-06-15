import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/theming/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onClose;

  const CustomAppBar({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorsManager.colorPrimary,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        Padding(
          padding:  EdgeInsets.only(right: 17.w,left: 17.w),
          child: GestureDetector(
            onTap: onClose,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
