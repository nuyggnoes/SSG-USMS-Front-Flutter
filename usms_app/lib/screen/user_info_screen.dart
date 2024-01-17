import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:usms_app/models/user_model.dart';
import 'package:usms_app/screen/register_screen.dart';
import 'package:usms_app/screen/security_test.dart';
import 'package:usms_app/screen/set_security_level_screen.dart';
import 'package:usms_app/screen/store_detail_screen.dart';
import 'package:usms_app/service/routes.dart';
import 'package:usms_app/service/test_register.dart';
import 'package:usms_app/widget/custom_info_button.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key, required this.context});
  final BuildContext context;
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

  logoutAction() async {
    await storage.delete(key: 'auto_login');
    await storage.delete(key: 'cookie');
    _pagePopAction();
  }

  _pagePopAction() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 30,
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      TextButton(
                        onPressed: () {
                          logoutAction();
                        },
                        child: Text(
                          "로그아웃 >",
                          style: TextStyle(color: Colors.red[400]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(14),
                      ),
                      color: Colors.blue[100],
                    ),
                    width: double.infinity,
                    height: 130,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '보유 CCTV 개수',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const Text(
                                '0개',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 30),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '보유 매장 개수',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const Text(
                                '0개',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 30),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.all(2),
                    height: 1000,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        // color: Colors.grey,
                        ),
                    child: Column(
                      children: [
                        CustomInfoButton(
                          buttonText: '회원정보 수정',
                          parentContext: widget.context,
                          route: Routes.registerUser,
                          icon: Icons.manage_accounts,
                        ),
                        CustomInfoButton(
                          buttonText: '보안레벨 설정',
                          parentContext: context,
                          route: Routes.securitySetting,
                          icon: Icons.admin_panel_settings,
                        ),
                        CustomInfoButton(
                          buttonText: '결제정보',
                          parentContext: context,
                          route: RegisterScreen.route,
                          icon: Icons.credit_card,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
