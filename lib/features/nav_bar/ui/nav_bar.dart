import 'package:flutter/material.dart';
import 'package:rommify_app/core/theming/colors.dart';
import 'package:rommify_app/features/create_room_screen/ui/create_room_screen.dart';
import 'package:rommify_app/features/explore_screen/ui/explore_screen.dart';

import 'package:rommify_app/features/profile/profile.dart';

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({super.key});

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  int _selectedIndex = 0;

  // قائمة الشاشات التي سيتم التنقل بينها
  final List<Widget> _screens = [
    const ExploreScreen(),
    const CreateRoomScreen(),
     ProfileScreen(),
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
              _buildNavItem(0, Icons.layers),
              _buildNavItem(1, Icons.search),
              _buildNavItem(2, Icons.person),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 40) / 3,
        height: 80,
        color: Colors.transparent,
        child: Icon(
          icon,
          color: _selectedIndex == index ? Colors.white : Colors.grey,
          size: 28,
        ),
      ),
    );
  }
}