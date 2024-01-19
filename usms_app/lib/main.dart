// package
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// api
import 'package:usms_app/api/firebase_api.dart';
import 'package:usms_app/service/routes.dart';

// route
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // 세로모드 고정
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await initializeDateFormatting();

  // 앱이 실행되기 전에 반드시 호출되어야 함.
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase SDK 초기화단계 (App을 Firebase 서비스를 사용할 수 있는 상태로 설정)
  // await Firebase.initializeApp();
  // await FirebaseApi().initNotifications();

  // initializeNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const url = 'https://usms.serveftp.com';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Push Notification',
      theme: ThemeData(
        // Scheme
        colorScheme: const ColorScheme(
          background: Colors.white,
          brightness: Brightness.light,
          primary: Colors.blue,
          onPrimary: Colors.black,
          secondary: Colors.green,
          onSecondary: Colors.amber,
          error: Colors.grey,
          onError: Colors.pink,
          onBackground: Colors.teal,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        primarySwatch: Colors.blue,
        highlightColor: Colors.blue[200],
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      navigatorKey: navigatorKey,
      // home: const Login(),
      // routes: {
      //   NotificationScreen.route: (context) => const NotificationScreen(),
      //   HomeScreen.route: (context) => const HomeScreen(),
      //   // RegisterScreen.route: (context) => const RegisterScreen(),
      //   RegisterStore.route: (context) => const RegisterStore(),
      //   SecurityLevel.route: (context) => const SecurityLevel(),
      //   StoreDetail.route: (context) => const StoreDetail(),
      //   SecondaryPasswordScreen.route: (context) =>
      //       const SecondaryPasswordScreen(),
      //   VerificationScreen.route: (context) => const VerificationScreen(),
      //   CCTVScreen.route: (context) => const CCTVScreen(),
      //   NotificationListScreen.route: (context) =>
      //       const NotificationListScreen(),
      //   StatisticScreen.route: (context) => const StatisticScreen(),
      // },
      initialRoute: Routes.login,
      routes: Routes.routes,
    );
  }
}
