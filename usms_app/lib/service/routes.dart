import 'package:flutter/material.dart';
import 'package:usms_app/screen/home_screen.dart';
import 'package:usms_app/screen/identity_verification_screen.dart';
import 'package:usms_app/screen/login_screen.dart';
import 'package:usms_app/screen/payment_information_screen.dart';
import 'package:usms_app/screen/register_screen.dart';
import 'package:usms_app/screen/register_store_screen.dart';
import 'package:usms_app/screen/set_security_level_screen.dart';
import 'package:usms_app/screen/store_detail_screen.dart';

class Routes {
  static const String login = '/';
  static const String identityVerification = '/identity-verification';
  static const String registerUser = '/register-user';
  static const String home = '/home';
  static const String registerStore = '/register-store';
  static const String storeDetail = '/store-detail';

  static const String payInfo = '/pay-info';

  static const String securitySetting = '/security-setting';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const Login(),
      identityVerification: (context) => const VerificationScreen(),
      registerUser: (context) =>
          const RegisterScreen(data: '', flag: null, routeCode: false),
      home: (context) => const HomeScreen(),
      securitySetting: (context) => const SecurityLevel(),
      registerStore: (context) => const RegisterStore(),
      storeDetail: (context) => const StoreDetail(),
      payInfo: (context) => const PayInfoScreen(),
    };
  }
}
