import 'package:flutter/material.dart';
import 'package:usms_app/screens/cctv_%20manual_screen.dart';
import 'package:usms_app/screens/cctv_detail_screen.dart';

import 'package:usms_app/screens/home_screen.dart';
import 'package:usms_app/screens/identity_verification_screen.dart';
import 'package:usms_app/screens/login_screen.dart';

import 'package:usms_app/screens/payment_information_screen.dart';
import 'package:usms_app/screens/register_screen.dart';

import 'package:usms_app/screens/secondary_password_screen.dart';
import 'package:usms_app/screens/set_security_level_screen.dart';
import 'package:usms_app/screens/splash_screen.dart';

class Routes {
  static const String splash = '/spash';
  static const String login = '/';
  static const String identityVerification = '/identity-verification';
  static const String registerUser = '/register-user';
  static const String home = '/home';

  static const String storeNotification = '/store-notification';

  static const String cctvDetail = '/cctv-detail';
  static const String cctvReplay = '/cctv-replay';
  static const String cctvManual = '/cctv-manual';

  static const String securitySetting = '/security-setting';
  static const String secondaryPassword = '/secondary-password';
  static const String payInfo = '/pay-info';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const Login(),
      identityVerification: (context) {
        int flagId = ModalRoute.of(context)!.settings.arguments as int;
        return VerificationScreen(flagId: flagId);
      },
      registerUser: (context) =>
          const RegisterScreen(data: '', flag: null, routeCode: false),
      home: (context) => const HomeScreen(),
      securitySetting: (context) => const SecurityLevel(),
      payInfo: (context) => const PayInfoScreen(),
      secondaryPassword: (context) => const SecondaryPasswordScreen(),
      cctvDetail: (context) => const CCTVScreen(),
      cctvManual: (context) => const CCTVManual(),
    };
  }
}
