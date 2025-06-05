import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rommify_app/core/helpers/constans.dart';
import 'package:rommify_app/core/theming/colors.dart';
import 'package:rommify_app/features/create_room_screen/ui/create_room_screen.dart';
import 'package:rommify_app/features/explore_screen/ui/explore_screen.dart';

import 'package:rommify_app/features/profile/profile.dart';

import '../../../core/helpers/shared_pref_helper.dart';
import '../../../core/widgets/check_server_connection.dart';

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({super.key});

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  int _selectedIndex = 1;

  @override
  void initState() {
    // TODO: implement initState
    CheckServerConnection.checkServerConnection();
    CheckServerNotificationConnection.checkServerNotificationConnection();


    super.initState();
  }
  // قائمة الشاشات التي سيتم التنقل بينها
  final List<Widget> _screens = [
    const ExploreScreen(),
    const CreateRoomScreen(),
    ProfileScreen(profileId: SharedPrefHelper.getString(SharedPrefKey.userId),),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.colorPrimary,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: (_selectedIndex * (MediaQuery.of(context).size.width / 3)) +
                (MediaQuery.of(context).size.width / 6) - 25,

            top: 15, // لضبط موقع الدائرة عموديًا
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, 'assets/images/explore.svg'),
              _buildNavItem(1, 'assets/images/generate.svg'),
              _buildNavItem(2, 'assets/images/profile.svg'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String icon) {
    return Padding(
      padding:  EdgeInsets.only(bottom: 5.h),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
            width: (MediaQuery.of(context).size.width - 40) / 3,
            height: 80.h,
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: SvgPicture.asset(icon,height: 5.h,width: 5.w,color: _selectedIndex == index ? Colors.white : Colors.grey,fit: BoxFit.contain,),
            )
        ),
      ),
    );
  }
}