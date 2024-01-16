import 'package:flutter/material.dart';
import 'package:usms_app/screen/home_screen.dart';
import 'package:usms_app/screen/identity_verification_screen.dart';
import 'package:usms_app/screen/login_screen.dart';
import 'package:usms_app/screen/register_store_screen.dart';
import 'package:usms_app/screen/set_security_level_screen.dart';

class Routes {
  static const String login = '/';
  static const String identityVerification = '/identity-verification';
  static const String home = '/home';
  static const String registerStore = '/register-store';

  static const String securitySetting = '/security-setting';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const Login(),
      identityVerification: (context) => const VerificationScreen(),
      home: (context) => const HomeScreen(),
      securitySetting: (context) => const SecurityLevel(),
      registerStore: (context) => const RegisterStore(),
      // Add more routes as needed
    };
  }
}
