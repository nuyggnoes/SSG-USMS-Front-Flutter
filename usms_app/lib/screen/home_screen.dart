import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const route = '/main';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = const FlutterSecureStorage();
  // ignore: prefer_typing_uninitialized_variables
  late String name = '';
  @override
  void initState() {
    super.initState();
    // getUsernameInStorage();
  }

  Future<void> getUsernameInStorage() async {
    final jsonString = await storage.read(key: 'login');
    final Map<String, dynamic> storageInfo = json.decode(jsonString!);
    setState(() {
      name = storageInfo['id'];
    });
    print(name);
  }

  logoutAction() async {
    await storage.delete(key: 'login');
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
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: AssetImage('assets/unknownuser.png'),
                  backgroundColor: Colors.white,
                ),
                accountName: Text(name),
                accountEmail: Text('$name@example.com'),
                onDetailsPressed: () {
                  print('detail clicked');
                },
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
                  Icons.settings,
                  color: Colors.grey,
                ),
                title: const Text(
                  'setting',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  print('Setting is Clicked');
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
              )
            ],
          ),
        ),
        body: const Center(
          child: Text('메인화면입니다.'),
        ),
      ),
    );
  }
}
