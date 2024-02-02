// package
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// api
import 'package:usms_app/api/firebase_api.dart';
import 'package:usms_app/routes.dart';

import 'package:usms_app/utils/cctv_provider.dart';

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
        ChangeNotifierProvider(
          create: (context) => CCTVProvider(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
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
            onError: Colors.red,
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
      ),
    );
  }
}
