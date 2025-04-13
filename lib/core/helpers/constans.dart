import 'package:rommify_app/core/helpers/shared_pref_helper.dart';

bool isLogin=false;

class SharedPrefKey
{
  static const String token='token';
  static String userId=SharedPrefHelper.getString('userId');
}