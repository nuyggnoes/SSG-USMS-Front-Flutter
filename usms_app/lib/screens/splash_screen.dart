import 'dart:async';

import 'package:flutter/material.dart';
import 'package:usms_app/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1500), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Login()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(204, 255, 255, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 500,
            ),
            Row(
              children: [
                Image.asset(
                  'assets/logo1.png',
                  width: double.infinity,
                ),
                const Text('USMS'),
              ],
            ),
            const Text(
              "© Copyright 2020, 내방니방(MRYR)",
              style: TextStyle(
                fontSize: 400,
                color: Color.fromRGBO(255, 255, 255, 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
