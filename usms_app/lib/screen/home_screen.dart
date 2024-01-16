import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:usms_app/models/user_model.dart';
import 'package:usms_app/screen/register_screen.dart';

import 'package:usms_app/screen/register_store_screen.dart';
import 'package:usms_app/screen/secondary_password_screen.dart';
import 'package:usms_app/screen/set_security_level_screen.dart';
import 'package:usms_app/screen/store_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const route = '/main';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = const FlutterSecureStorage();
  late String? name = '';
  late String? email = '';
  int state = 0;
  late Icon securityIcon;
  //로그인 한 userDTO
  late User user;

  @override
  void initState() {
    super.initState();
    getUserInfoFromStorage();
  }

  Future<void> getUserInfoFromStorage() async {
    final username = await storage.read(key: 'cookie');
    print('username = $username');
    Response response;
    var baseoptions = BaseOptions(
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
      baseUrl: "http://10.0.2.2:3003",
    );
    Dio dio = Dio(baseoptions);

    var param = {
      'username': username,
    };
    print(param);
    try {
      response = await dio.get('/login', data: param);
      if (response.statusCode == 200) {
        print('====================userInfo 200=====================');
        print('[RES BODY] : ${response.data}');
        user = User.fromMap(response.data);
        setState(() {
          name = user.person_name;
          email = user.email;
          state = user.security_state;
        });
        await storage.write(key: 'userInfo', value: jsonEncode(response.data));
        print('유저 보안 레벨 : $state');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        print("[ERROR] : [$e]");
        // 400 에러의 body
        print('[ERR Body] : ${e.response?.data}');
      }
    }
  }

  Icon getSecurityLevel() {
    setState(() {
      if (state == 0) {
        securityIcon = Icon(
          Icons.gpp_bad_outlined,
          color: Colors.red.shade400,
          size: 70,
        );
      } else if (state == 1) {
        securityIcon = const Icon(
          Icons.health_and_safety_outlined,
          color: Colors.amber,
          size: 70,
        );
      } else {
        securityIcon = const Icon(
          Icons.verified_user_outlined,
          color: Colors.green,
          size: 70,
        );
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
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue[200],
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          elevation: 2,
          title: const Text('메인화면'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                ),
                accountName: Row(
                  children: [
                    Text(
                      '$name님',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      width: 55,
                    ),
                    // Icon(
                    //   Icons.gpp_bad_outlined,
                    //   color: getSecurityLevel(),
                    //   size: 70,
                    // ),
                    getSecurityLevel(),
                  ],
                ),
                accountEmail: Text(
                  '$email',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                // onDetailsPressed: () {
                //   print('detail clicked');
                // },
              ),
              ListTile(
                leading: const Icon(
                  Icons.policy_outlined,
                  color: Colors.grey,
                ),
                title: const Text(
                  '보안레벨 설정',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  print('Security Level Clicked');
                  Navigator.pushNamed(context, SecurityLevel.route);
                },
                trailing: const Icon(
                  Icons.add,
                  color: Colors.grey,
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.account_circle_outlined,
                  color: Colors.grey,
                ),
                title: const Text(
                  '회원정보 수정',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  print('Edit User Info Clicked');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(
                        data: 'data',
                        flag: null,
                        routeCode: 2,
                      ),
                    ),
                  );
                },
                trailing: const Icon(
                  Icons.add,
                  color: Colors.grey,
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout_rounded,
                  color: Colors.grey,
                ),
                title: const Text(
                  '로그아웃',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  logoutAction();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.science_outlined,
                  color: Colors.grey,
                ),
                title: const Text(
                  '매장 상세 페이지',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, StoreDetail.route);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.science_outlined,
                  color: Colors.grey,
                ),
                title: const Text(
                  '2차 비밀번호',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, SecondaryPasswordScreen.route);
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RegisterStore.route);
            },
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black87,
                    ),
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_outlined,
                        size: 80,
                        color: Colors.grey,
                      ),
                      Text(
                        '매장을 추가해주세요',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.teal[100],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Column(
                    children: [
                      Text('서비스 시작하기'),
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
