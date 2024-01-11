// package
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_fonts/google_fonts.dart';

// api
import 'package:usms_app/api/firebase_api.dart';

// screen
import 'package:usms_app/screen/home_screen.dart';
import 'package:usms_app/screen/login_screen.dart';
import 'package:usms_app/screen/notification_screen.dart';
import 'package:usms_app/screen/register_store_screen.dart';
import 'package:usms_app/screen/secondary_password_screen.dart';
import 'package:usms_app/screen/set_security_level_screen.dart';
import 'package:usms_app/screen/store_detail_screen.dart';

// route
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  await initializeDateFormatting();

  // 앱이 실행되기 전에 반드시 호출되어야 함.
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase SDK 초기화단계 (App을 Firebase 서비스를 사용할 수 있는 상태로 설정)
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();

  // initializeNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Push Notification',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      navigatorKey: navigatorKey,
      home: const Login(),
      routes: {
        NotificationScreen.route: (context) => const NotificationScreen(),
        HomeScreen.route: (context) => const HomeScreen(),
        RegisterStore.route: (context) => const RegisterStore(),
        SecurityLevel.route: (context) => const SecurityLevel(),
        StoreDetail.route: (context) => const StoreDetail(),
        SecondaryPasswordScreen.route: (context) =>
            const SecondaryPasswordScreen(),
      },
    );
  }
}
