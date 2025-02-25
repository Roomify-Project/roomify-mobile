import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rommify_app/core/theming/colors.dart';

import '../../create_room_screen/ui/widget/circle_widget.dart';

class GenerateRoomScreen extends StatelessWidget {
  const GenerateRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.colorPrimary,
      body: Stack(
        children: [
          CircleWidget(),
          Column(
            children: [

            ],
          ),

        ],
      ),
    );
  }
}
