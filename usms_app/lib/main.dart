// package
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

// api
import 'package:usms_app/api/firebase_api.dart';
import 'package:usms_app/screen/cctv_replay_screen.dart';
import 'package:usms_app/screen/hero_test_screen.dart';
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
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();

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
      initialRoute: Routes.login,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Routes.cctvReplay:
            return MaterialPageRoute(builder: (context) => const CCTVReplay());
          default:
            return MaterialPageRoute(
              builder: (context) => const TestTest(),
            );
        }
      },
      routes: Routes.routes,
    );
  }
}
