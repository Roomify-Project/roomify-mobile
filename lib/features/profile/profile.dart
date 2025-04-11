import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/helpers/extensions.dart';
import 'package:rommify_app/core/routing/routes.dart';
import 'package:rommify_app/core/theming/colors.dart';
import 'package:rommify_app/features/profile/edit_profile_screen.dart';

import '../../core/widgets/custom_gird_view.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? selectedIcon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.mainColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Column(
              children: [
                // Image and info row
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/1O0A0210.jpg'),
                    ),
                    SizedBox(width: 35),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Abanoub Maged",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Interior Designer",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        Text(
                          "@abanoub185",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text("1.3k followers",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                            SizedBox(width: 20),
                            Text("45 following",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                // Interactive icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIcon(Icons.favorite, 'favorite', () {}),
                    SizedBox(width: 30.w),
                    _buildIcon(Icons.history, 'history', () {}),
                    SizedBox(width: 30.w),
                    _buildIcon(Icons.bookmark, 'bookmark', () {}),
                  ],
                ),
                SizedBox(height: 20.h),
                // Image Grid - Modified mainAxisSpacing to 0
                const Expanded(
                  child: CustomGridViewProfile(),
                ),
              ],
            ),
          ),
          // Settings icon at the top
          Positioned(
            top: 25.h,
            right: 10.w,
            child: Row(
              children: [
                InkWell(
                  child: Icon(
                    Icons.email_outlined,
                    color: Colors.white,
                    size: 28.sp,
                  ),
                  onTap: () {
                    context.pushNamed(Routes.chatsScreen);
                  },
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditProfileScreen()));
                    },
                    child:
                        Icon(Icons.settings, color: Colors.white, size: 28.sp)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Method to build icons that change color when tapped
  Widget _buildIcon(IconData icon, String key, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIcon = key;
        });
        onTap.call();
      },
      child: Icon(
        icon,
        color: selectedIcon == key ? Colors.white : Colors.grey,
        size: 35.h,
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  final String imageUrl;
  final String profileImageUrl;
  final VoidCallback onExpand;
  final bool isExpanded;

  const ImageCard({
    super.key,
    required this.imageUrl,
    required this.profileImageUrl,
    required this.onExpand,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 8,
          left: 8,
          child: CircleAvatar(
            radius: 12,
            backgroundImage: AssetImage(profileImageUrl),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onExpand,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isExpanded)
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bookmark_border,
                          color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Icon(Icons.favorite_border,
                          color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Icon(Icons.download, color: Colors.white, size: 20),
                      SizedBox(width: 10),
                    ],
                  ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                    size: 14,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
