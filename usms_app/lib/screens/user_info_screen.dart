import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:usms_app/models/user_model.dart';
import 'package:usms_app/routes.dart';
import 'package:usms_app/screens/login_screen.dart';

import 'package:usms_app/screens/register_screen.dart';
import 'package:usms_app/services/user_service.dart';
import 'package:usms_app/widget/custom_info_button.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key, required this.context});
  final BuildContext context;
  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final UserService userService = UserService();
  late User? user;

  String name = '';
  String phone = '';
  String username = '';
  String email = '';

  int securityState = 0;
  Icon securityIcon = const Icon(Icons.gpp_bad_outlined);
  Color securityColor = Colors.grey;

  logoutAction() async {
    await storage.delete(key: 'auto_login');
    await storage.delete(key: 'cookie');
    await storage.delete(key: 'userInfo');
    print('userService.logout()');
    // Navigator
    // 여기에 추가
    Navigator.pop(context);
  }

  @override
  void initState() {
    try {
      userService.getUserInfo().then((value) {
        setState(() {
          user = value;
          name = user!.person_name;
          phone = user!.phone_number;
          username = user!.username;
          email = user!.email;
          securityState = user!.security_state;
          getSecurityLevel();
        });
      });
    } catch (e) {
      print("Error in initState: $e");
    }
    super.initState();
  }

  Icon getSecurityLevel() {
    setState(() {
      if (Provider.of<User>(context, listen: false).security_state == 0) {
        securityIcon = const Icon(
          Icons.gpp_bad_outlined,
          color: Colors.white,
        );
        securityColor = Colors.red.shade400;
      } else if (Provider.of<User>(context, listen: false).security_state ==
          1) {
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
      appBar: AppBar(
        title: const Text('마이페이지'),
        leading: const Icon(Icons.person),
      ),
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
                                Provider.of<User>(context).person_name,
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
                                      ' Lv. ${Provider.of<User>(context).security_state} ',
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
                          // userService.logoutAction(() {
                          //   Navigator.pushNamedAndRemoveUntil(
                          //       context, '/', (route) => false);
                          // });
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
                      color: Colors.grey[200],
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
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(
                                    data: '', flag: null, routeCode: false),
                              ),
                            );
                          },
                          child: const Text('회원정보 수정'),
                        ),
                        CustomInfoButton(
                          buttonText: '회원정보 수정',
                          parentContext: widget.context,
                          route: Routes.registerUser,
                          icon: Icons.manage_accounts,
                        ),
                        CustomInfoButton(
                          buttonText: '보안레벨 설정',
                          parentContext: widget.context,
                          route: Routes.securitySetting,
                          icon: Icons.admin_panel_settings,
                        ),
                        CustomInfoButton(
                          buttonText: '결제정보',
                          parentContext: widget.context,
                          route: Routes.payInfo,
                          icon: Icons.credit_card,
                        ),
                        CustomInfoButton(
                          buttonText: '2차 비밀번호',
                          parentContext: widget.context,
                          route: Routes.secondaryPassword,
                          icon: Icons.password_rounded,
                        ),
                        CustomInfoButton(
                          buttonText: 'Hero Test',
                          parentContext: context,
                          route: Routes.heroTest,
                          icon: Icons.science,
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
