import 'package:flutter/material.dart';
import 'package:usms_app/models/user_model.dart';

class UserProvider with ChangeNotifier {
  User _user = User(
    username: '',
    password: '',
    nickname: '',
    email: '',
    phoneNumber: '',
    securityLevel: 0,
    is_lock: false,
  );

  User get user => _user;

  void updateUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }
}
