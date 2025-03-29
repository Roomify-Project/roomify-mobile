import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Stack(
        alignment: Alignment.center,
        children: [
          const CircleAvatar(
            radius: 67,
            backgroundColor: Colors.grey,
            backgroundImage: AssetImage('assets/images/1O0A0210.jpg'),
          ),
          Container(
            width: 134,
            height: 134,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.edit,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}