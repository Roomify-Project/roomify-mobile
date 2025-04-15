import 'package:flutter/material.dart';
import 'package:rommify_app/core/routing/routes.dart';
import 'package:rommify_app/features/create_room_screen/ui/create_room_screen.dart';
import 'package:rommify_app/features/explore_screen/ui/explore_screen.dart';
import 'package:rommify_app/features/forget_password/ui/forget_password.dart';
import 'package:rommify_app/features/generate_room_screen/ui/generate_room_screen.dart';
import 'package:rommify_app/features/main_screen/ui/main_screen.dart';
import 'package:rommify_app/features/sign_up/ui/sign_up_screen.dart';
import '../../features/log_in/ui/log_in_screan.dart';
import '../../features/nav_bar/ui/nav_bar.dart';


class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.signUpScreen:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
        );
      case Routes.forgetPassword: // Changed from forgetPassword
        return MaterialPageRoute(
          builder: (_) => const ForgetPasswordDialog(), // New screen
        );
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => const LogInScreen(),
        );
      case Routes.navBar:
        return MaterialPageRoute(
          builder: (_) => const NavBarScreen(),
        );
      case Routes.createRoomScreen:
        return MaterialPageRoute(
          builder: (_) => const CreateRoomScreen(),
        );
      case Routes.generateRoomScreen:
        return MaterialPageRoute(
          builder: (_) => const GenerateRoomScreen(),
        );
      case Routes.exploreScreen:
        return MaterialPageRoute(
          builder: (_) => const ExploreScreen(),
        );
      case Routes.mainScreen:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
        );
      default:
        return null;
    }
  }
}