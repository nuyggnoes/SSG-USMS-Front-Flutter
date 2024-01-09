import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const route = '/main';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue[200],
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 40,
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          elevation: 2,
          title: const Text('메인화면'),
        ),
        body: const Center(
          child: Text('메인화면입니다.'),
        ),
      ),
    );
  }
}
