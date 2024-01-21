import 'package:flutter/material.dart';
import 'package:usms_app/screen/cctv_detail_screen.dart';
import 'package:usms_app/screen/cctv_replay_screen.dart';
import 'package:usms_app/screen/home_screen.dart';
import 'package:usms_app/screen/identity_verification_screen.dart';
import 'package:usms_app/screen/login_screen.dart';
import 'package:usms_app/screen/payment_information_screen.dart';
import 'package:usms_app/screen/register_screen.dart';
import 'package:usms_app/screen/register_store_screen.dart';
import 'package:usms_app/screen/secondary_password_screen.dart';
import 'package:usms_app/screen/set_security_level_screen.dart';
import 'package:usms_app/screen/store_detail_screen.dart';
import 'package:usms_app/screen/store_detail_screen2.dart';
import 'package:usms_app/screen/test_screen.dart';

class Routes {
  static const String login = '/';
  static const String identityVerification = '/identity-verification';
  static const String registerUser = '/register-user';
  static const String home = '/home';
  static const String registerStore = '/register-store';
  static const String storeDetail = '/store-detail';
  static const String storeDetail2 = '/store-detail2';

  static const String payInfo = '/pay-info';

  static const String securitySetting = '/security-setting';
  static const String secondaryPassword = '/secondary-password';

  static const String cctvDetail = '/cctv-detail';
  static const String cctvReplay = '/cctv-replay';

  // test
  static const String heroTest = '/hero-test';

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
      secondaryPassword: (context) => const SecondaryPasswordScreen(),
      cctvDetail: (context) => const CCTVScreen(),
      cctvReplay: (context) => const CCTVReplay(),
      heroTest: (contest) => const TestScreen(),
      storeDetail2: (context) => const StoreDetail2()
    };
  }
}
