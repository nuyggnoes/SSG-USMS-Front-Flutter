import 'package:flutter/material.dart';
import 'package:usms_app/models/cctv_model.dart';
import 'package:usms_app/screens/cctv_%20manual_screen.dart';
import 'package:usms_app/screens/cctv_detail_screen.dart';
import 'package:usms_app/screens/cctv_replay_screen.dart';
import 'package:usms_app/screens/hero_test_screen.dart';
import 'package:usms_app/screens/home_screen.dart';
import 'package:usms_app/screens/identity_verification_screen.dart';
import 'package:usms_app/screens/login_screen.dart';
import 'package:usms_app/screens/payment_information_screen.dart';
import 'package:usms_app/screens/register_screen.dart';
import 'package:usms_app/screens/register_store_screen.dart';
import 'package:usms_app/screens/secondary_password_screen.dart';
import 'package:usms_app/screens/set_security_level_screen.dart';
import 'package:usms_app/screens/splash_screen.dart';
import 'package:usms_app/screens/store_detail_screen.dart';
import 'package:usms_app/screens/store_detail_screen2.dart';
import 'package:usms_app/screens/store_notification_screen.dart';

class Routes {
  static const String splash = '/spash';

  static const String login = '/';
  static const String identityVerification = '/identity-verification';
  static const String registerUser = '/register-user';

  static const String home = '/home';
  // store
  static const String registerStore = '/register-store';
  static const String storeDetail = '/store-detail';
  static const String storeDetail2 = '/home/store-detail2';
  static const String storeNotification = '/store-notification';
  // cctv
  static const String cctvDetail = '/cctv-detail';
  static const String cctvReplay = '/cctv-replay';
  static const String cctvManual = '/cctv-manual';

  static const String securitySetting = '/security-setting';
  static const String secondaryPassword = '/secondary-password';

  static const String payInfo = '/pay-info';
  // test
  static const String heroTest = '/hero-test';
  static const String provider = '/provider';

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
      // registerStore: (context) => const RegisterStore(),
      // storeDetail: (context) => const StoreDetail(),
      payInfo: (context) => const PayInfoScreen(),
      secondaryPassword: (context) => const SecondaryPasswordScreen(),
      cctvDetail: (context) => const CCTVScreen(),
      // cctvReplay: (context) {
      //   final CCTV cctv = ModalRoute.of(context)!.settings.arguments as CCTV;
      //   return CCTVReplay(cctv: cctv, userId: null,);
      // },
      cctvManual: (context) => const CCTVManual(),
      provider: (context) => const ProviderTest(),

      // heroTest: (context) => const VideoPlayerScreen(),

      // storeNotification: (context) => const StoreNotification(),
      // storeDetail2: (context) => const StoreDetail2()
    };
  }
}
