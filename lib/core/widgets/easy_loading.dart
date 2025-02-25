import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../theming/colors.dart';
class EasyLoadingWidget
{

  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.rotatingCircle  // Pulsing circles animation
      ..loadingStyle = EasyLoadingStyle.dark  // Light style for better visibility
      ..indicatorSize = 50.0  // Size of the indicator
      ..radius = 15.0  // Radius of the background circle
      ..progressColor = Colors.teal  // Color of the progress bar
      ..backgroundColor = ColorsManager.mainBurble  // Background color behind the loading indicator
      ..indicatorColor = ColorsManager.mainBurble  // Color of the loading indicator
      ..textColor = ColorsManager.mainBurble  // Color of the text
      ..maskColor = ColorsManager.mainBurble// Background mask color
      ..userInteractions = false  // Disable interactions during loading
      ..dismissOnTap = false;  // Do not dismiss the loading on tap
  }
}