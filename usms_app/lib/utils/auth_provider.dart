import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool isLoggedIn() {
    return _isLoggedIn;
  }

  // 로그인 로직
  void login() {
    // 실제 로그인 로직이 여기에 들어갈 것입니다.
    // 로그인이 성공하면 _isLoggedIn를 true로 설정하고
    // ChangeNotifier의 notifyListeners를 호출하여 위젯들에게 알립니다.
    _isLoggedIn = true;
    notifyListeners();
  }
}
