import 'package:flutter/material.dart';
import 'package:rommify_app/core/routing/routes.dart';
import 'package:rommify_app/features/chat/ui/chant_friend_screen.dart';
import 'package:rommify_app/features/chat/ui/chat_screen.dart';
import 'package:rommify_app/features/create_room_screen/ui/create_room_screen.dart';
import 'package:rommify_app/features/explore_screen/ui/explore_screen.dart';
import 'package:rommify_app/features/generate_room_screen/ui/generate_room_screen.dart';
import 'package:rommify_app/features/main_screen/ui/main_screen.dart';
import 'package:rommify_app/features/profile/add_post.dart';
import 'package:rommify_app/features/profile/profile.dart';
import 'package:rommify_app/features/sign_up/ui/sign_up_screen.dart';

import '../../features/forget_password/ui/forget_password.dart';
import '../../features/log_in/ui/log_in_screan.dart';
import '../../features/nav_bar/ui/nav_bar.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    // final arguments = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {

      case Routes.signUpScreen:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
        );
      case Routes.navBar:
        return MaterialPageRoute(
          builder: (_) => const NavBarScreen(),
        );
      case Routes.forgetPassword: // Changed from forgetPassword
        return MaterialPageRoute(
          builder: (_) => const ForgetPasswordDialog(), // New screen
        );
      case Routes.profile: // Cha
        final arguments = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) =>  ProfileScreen(profileId: arguments?['profileId'] as String??""), // New screen
        );
      case Routes.createRoomScreen:
        return MaterialPageRoute(
          builder: (_) => const CreateRoomScreen(),
        );
      case Routes.generateRoomScreen:
        return MaterialPageRoute(
          builder: (_) =>  const GenerateRoomScreen(),
        );
      case Routes.exploreScreen:
        return MaterialPageRoute(
          builder: (_) =>  const ExploreScreen(),
        );
      case Routes.mainScreen:
        final arguments = settings.arguments as Map<String, dynamic>?;

        return MaterialPageRoute(
          builder: (_) =>   MainScreen(postId: arguments?['postId'] as String??"",
          ),
        );
      case Routes.chatsScreen:
        return MaterialPageRoute(
          builder: (_) =>   ChatsScreen(),
        );
      case Routes.chatsFriendsScreen:
        final arguments = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) =>   ChatFriendScreen(getProfileDataModel: arguments?['getProfileDataModel'],),
        );
      case Routes.addPost:
        return MaterialPageRoute(
          builder: (_) =>   AddPostPage(),
        );
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => const LogInScreen(),
        );
      default:
        return null;
    }
  }
}
