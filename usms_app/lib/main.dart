// package
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

// api
import 'package:usms_app/api/firebase_api.dart';
import 'package:usms_app/routes.dart';

import 'package:usms_app/screens/cctv_replay_screen.dart';
import 'package:usms_app/screens/test_screen.dart';
import 'package:usms_app/utils/store_provider.dart';
import 'package:usms_app/utils/user_provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => StoreProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Push Notification',
        theme: ThemeData(
          // Scheme
          colorScheme: const ColorScheme(
            background: Colors.white,
            brightness: Brightness.light,
            primary: Colors.blueAccent,
            onPrimary: Colors.black,
            secondary: Colors.green,
            onSecondary: Colors.amber,
            error: Colors.red,
            onError: Colors.pink,
            onBackground: Colors.blueAccent,
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
        routes: Routes.routes,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case Routes.cctvReplay:
              // settings.arguments를 통해 전달된 값을 얻어옴
              final int cctvId = settings.arguments as int;
              return MaterialPageRoute(
                builder: (context) => CCTVReplay(cctvId: cctvId),
              );
            // 다른 라우트들에 대한 처리 추가
            // ...
            default:
              // 기본적으로 알 수 없는 경로에 대한 처리
              return MaterialPageRoute(
                  builder: (context) => const TestScreen());
          }
        },
      ),
    );
  }
}
