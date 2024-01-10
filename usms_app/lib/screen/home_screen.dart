import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:usms_app/models/user_model.dart';
import 'package:usms_app/screen/register_store_screen.dart';
import 'package:usms_app/screen/set_security_level_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const route = '/main';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = const FlutterSecureStorage();
  late String name = '';
  //로그인 한 userDTO
  dynamic user;

  @override
  void initState() {
    super.initState();
    getUserInfoFromStorage();
  }

  Future<void> getUserInfoFromStorage() async {
    final jsonString = await storage.read(key: 'login');
    final Map<String, dynamic> storageInfo = json.decode(jsonString!);
    print('[STORAGE INFORMATION] $storageInfo');
    setState(() {
      name = storageInfo['username'];
    });
  }

  logoutAction() async {
    await storage.delete(key: 'auto_login');
    await storage.delete(key: 'login');
    // Navigator.popUntil(context, ModalRoute.withName('/'));
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
                    const Icon(
                      Icons.gpp_bad_outlined,
                      color: Colors.green,
                      size: 70,
                    ),
                  ],
                ),
                accountEmail: Text(
                  '$name@example.com',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                // onDetailsPressed: () {
                //   print('detail clicked');
                // },
              ),
              // SizedBox(
              //   height: 100,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Icon(
              //         Icons.gpp_bad_outlined,
              //         color: Colors.red[400],
              //         size: 50,
              //       ),
              //       const Text(
              //         '현재 보안레벨은 0레벨입니다.',
              //         style: TextStyle(
              //           color: Colors.grey,
              //           fontSize: 16,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
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
            ],
          ),
        ),
        body: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RegisterStore.route);
            },
            child: Container(
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
          ),
        ),
      ),
    );
  }
}
