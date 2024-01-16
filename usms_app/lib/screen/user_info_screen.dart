import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:usms_app/models/user_model.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final storage = const FlutterSecureStorage();

  String name = '';

  String phone = '';

  String username = '';

  String email = '';

  int securityState = 0;
  Icon securityIcon = const Icon(Icons.gpp_bad_outlined);
  Color securityColor = Colors.grey;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    final jsonString = await storage.read(key: 'userInfo');

    if (jsonString != null) {
      // 역직렬화
      final Map<String, dynamic> userMap = jsonDecode(jsonString);

      // 사용자 정보로 변환
      User user = User.fromMap(userMap);
      // 이제 user를 사용할 수 있음

      setState(() {
        name = user.person_name;
        phone = user.phone_number;
        username = user.username;
        email = user.email;
        securityState = user.security_state;
        getSecurityLevel();
      });
    }
    return null;
  }

  Icon getSecurityLevel() {
    setState(() {
      if (securityState == 0) {
        securityIcon = const Icon(
          Icons.gpp_bad_outlined,
          color: Colors.white,
        );
        securityColor = Colors.red.shade400;
      } else if (securityState == 1) {
        securityIcon = const Icon(
          Icons.health_and_safety_outlined,
          color: Colors.white,
        );
        securityColor = Colors.amber;
      } else {
        securityIcon = const Icon(
          Icons.verified_user_outlined,
          color: Colors.white,
        );
        securityColor = Colors.green;
      }
    });
    return securityIcon;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
            ),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.account_circle_rounded,
                      size: 80,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 1, horizontal: 4),
                          decoration: BoxDecoration(color: securityColor),
                          child: Row(
                            children: [
                              securityIcon,
                              Text(
                                ' Lv. $securityState  ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  width: double.infinity,
                  height: 150,
                  child: const Row(
                    children: [
                      Card(
                        margin: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Home page',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
