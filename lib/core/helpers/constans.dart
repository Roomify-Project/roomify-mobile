import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:rommify_app/core/helpers/shared_pref_helper.dart';

bool isLogin=false;

class SharedPrefKey
{
  static const String name='name';
  static const String data='data';
  static const String image='image';


  static const String token='token';
  static String userId='userId';
}
class Constants {
  static String defaultImagePerson='https://th.bing.com/th/id/OIP.5kU_nQdgEEPluSjSXhKZSAHaHa?rs=1&pid=ImgDetMain';
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

}