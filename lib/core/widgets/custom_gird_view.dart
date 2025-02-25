import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../features/profile/profile.dart';

class CustomGirdView extends StatefulWidget {
  const CustomGirdView({super.key});

  @override
  State<CustomGirdView> createState() => _CustomGirdViewState();
}

class _CustomGirdViewState extends State<CustomGirdView> {
  List<bool> isExpandedList =
  List.generate(10, (index) => false);
 // Initialize list with false
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 15, // Changed from previous value to 0
        childAspectRatio: 169 / 128, // Set the aspect ratio
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return ImageCard(
          imageUrl: 'assets/images/Group 25.png',
          profileImageUrl: 'assets/images/1O0A0210.jpg',
          onExpand: () {
            setState(() {
              isExpandedList[index] = !isExpandedList[index];
            });
          },
          isExpanded: isExpandedList[index],
        );
      },
    );
  }
}
