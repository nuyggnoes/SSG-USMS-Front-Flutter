import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:usms_app/models/user_model.dart';
import 'package:usms_app/screen/register_store_screen.dart';

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
      name = storageInfo['id'];
    });
  }

  logoutAction() async {
    await storage.delete(key: 'auto_login');
    Navigator.popUntil(context, ModalRoute.withName('/'));
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
                accountName: Text(
                  '$name님',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                  ),
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
              IconButton(
                onPressed: () {
                  print('SecurityLevel!');
                },
                icon: const Icon(
                  Icons.security,
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.home,
                  color: Colors.grey,
                ),
                title: const Text(
                  'home',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  print('Home is Clicked');
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
                  'Logout',
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
