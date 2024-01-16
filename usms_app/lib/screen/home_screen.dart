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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final storage = const FlutterSecureStorage();
  late String? name = '';
  late String? email = '';
  int state = 0;
  late Icon securityIcon;
  //로그인 한 userDTO
  late User user;

  //애니메이션
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    getUserInfoFromStorage();

    // 애니메이션 컨트롤러 초기화
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Offset 애니메이션 설정
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
    // 페이지가 나타날 때 애니메이션 실행
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue[200],
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Colors.white,
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
          child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return SlideTransition(
                  position: _offsetAnimation,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 500,
                      decoration: BoxDecoration(
                        // color: const Color.fromARGB(255, 170, 214, 211),
                        color: Colors.blue[300],
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Text(
                                  '서비스 ',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  '시작하기',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Image.asset(
                              'assets/main_img.png',
                              width: double.infinity,
                            ),
                          ),
                          Expanded(
                            child: Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  // color: Color.fromARGB(255, 130, 186, 182),
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(14),
                                    bottomRight: Radius.circular(14),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        flex: 7,
                                        child: Text(
                                          '서비스를 이용하기 위해 매장을 추가해주세요.',
                                          softWrap: true,
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          print('추가하기');
                                          Navigator.pushNamed(
                                              context, RegisterStore.route);
                                        },
                                        child: const Text(
                                          '추가',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
