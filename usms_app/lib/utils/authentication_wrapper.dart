import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usms_app/screens/home_screen.dart';
import 'package:usms_app/screens/login_screen.dart';
import 'package:usms_app/utils/auth_provider.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // 사용자가 로그인 되었는지 확인
    if (authProvider.isLoggedIn()) {
      return const HomeScreen(); // 로그인 되었으면 HomeScreen으로 이동
    } else {
      return const Login(); // 로그인 안 되어 있으면 LoginScreen을 표시
    }
  }
}
