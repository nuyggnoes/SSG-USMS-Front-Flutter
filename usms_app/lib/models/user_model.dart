import 'package:flutter/material.dart';

class User with ChangeNotifier {
  final String username;
  final String password;
  final String nickname;
  final String email;
  final String phoneNumber;
  int? securityLevel;
  bool? is_lock;
  int? id;

  User({
    required this.username,
    required this.password,
    required this.nickname,
    required this.email,
    required this.phoneNumber,
    this.securityLevel,
    this.is_lock,
    this.id,
  });

  User.fromJson(Map<String, dynamic> json)
      : username = json["username"],
        password = json['password'],
        nickname = json['nickname'],
        email = json['email'],
        phoneNumber = json['phoneNumber'],
        securityLevel = json['securityLevel'],
        is_lock = json['is_lock'];

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'nickname': nickname,
        'email': email,
        'phoneNumber': phoneNumber,
      };
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      nickname: map['nickname'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      securityLevel: map['securityLevel'],
      is_lock: map['is_lock'],
    );
  }
}
