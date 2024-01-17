import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:usms_app/main.dart';
import 'package:usms_app/models/user_model.dart';
import 'package:usms_app/screen/notification_list_screen.dart';
import 'package:usms_app/screen/register_screen.dart';

import 'package:usms_app/screen/register_store_screen.dart';
import 'package:usms_app/screen/secondary_password_screen.dart';
import 'package:usms_app/screen/set_security_level_screen.dart';
import 'package:usms_app/screen/statistic_screen.dart';
import 'package:usms_app/screen/store_detail_screen.dart';
import 'package:usms_app/screen/user_info_screen.dart';
import 'package:usms_app/service/routes.dart';
import 'package:usms_app/widget/store_register_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const route = '/main';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final storage = const FlutterSecureStorage();
  late String? name = '';
  late String? email = '';
  int state = 0;
  late Icon securityIcon;

  late User user;

  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  late List<Widget> widgetOptions;

  @override
  void initState() {
    super.initState();
    getUserInfoFromStorage();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    widgetOptions = <Widget>[
      RegisterStoreWidget(
          animationController: _animationController,
          offsetAnimation: _offsetAnimation,
          opacityAnimation: _opacityAnimation),
      const NotificationListScreen(),
      const StatisticScreen(),
      MyPageScreen(
        context: super.context,
      ),
    ];

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

  int currentPageIndex = 0;
  int selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 2, color: Colors.grey),
          ),
        ),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_sharp),
              label: '알림',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              label: '통계',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '내 정보',
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Colors.blue[400],
          iconSize: 37,
          onTap: _onItemTapped,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      body: SafeArea(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[400],
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
                      routeCode: false,
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
                Navigator.pushNamed(context, Routes.storeDetail);
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
      // body: RegisterStoreWidget(
      //     animationController: _animationController,
      //     offsetAnimation: _offsetAnimation,
      //     opacityAnimation: _opacityAnimation),
    );
  }
}
