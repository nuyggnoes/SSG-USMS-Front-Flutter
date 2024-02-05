import 'package:flutter/material.dart';

class User with ChangeNotifier {
  final String username;
  final String nickname;
  final String email;
  final String phoneNumber;
  final String? password;
  int? securityLevel;
  int? id;

  User({
    required this.username,
    required this.nickname,
    required this.email,
    required this.phoneNumber,
    this.password,
    this.securityLevel,
    this.id,
  });

  User.fromJson(Map<String, dynamic> json)
      : username = json["username"],
        password = json['password'],
        nickname = json['nickname'],
        email = json['email'],
        phoneNumber = json['phoneNumber'],
        securityLevel = json['securityLevel'];

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
      nickname: map['nickname'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      securityLevel: map['securityState'],
    );
  }

  static List<User> fromMapToUserModel(List<dynamic> list) {
    List<User> usernameList = list.map((json) {
      return User.fromMap(json);
    }).toList();

    return usernameList;
  }
}
