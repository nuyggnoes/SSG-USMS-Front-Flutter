import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:usms_app/models/user_model.dart';
import 'package:usms_app/routes.dart';

import 'package:usms_app/services/user_service.dart';
import 'package:usms_app/utils/store_provider.dart';
import 'package:usms_app/utils/user_provider.dart';
import 'package:usms_app/widget/custom_info_button.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final UserService userService = UserService();
  late User user;

  String name = '';
  String phone = '';
  String username = '';
  String email = '';

  int? securityState = 0;
  Icon securityIcon = const Icon(Icons.gpp_bad_outlined);
  Color securityColor = Colors.grey;

  logoutAction() async {
    await storage.delete(key: 'auto_login');
    await storage.delete(key: 'cookie');
    await storage.delete(key: 'userInfo');

    Future.microtask(() {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    // try {
    //   userService.getUserInfo().then((value) {
    //     setState(() {
    //       user = value;
    //       name = user!.nickname;
    //       phone = user!.phoneNumber;
    //       username = user!.username;
    //       email = user!.email;
    //       securityState = user!.securityLevel;
    //       getSecurityLevel();
    //     });
    //   });
    // } catch (e) {
    //   print("Error in initState: $e");
    // }

    super.initState();
  }

  Icon getSecurityLevel() {
    setState(() {
      if (Provider.of<User>(context, listen: false).securityLevel == 0) {
        securityIcon = const Icon(
          Icons.gpp_bad_outlined,
          color: Colors.white,
        );
        securityColor = Colors.red.shade400;
      } else if (Provider.of<User>(context, listen: false).securityLevel == 1) {
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
    user = Provider.of<UserProvider>(context).user;
    name = user.nickname;
    phone = user.phoneNumber;
    username = user.username;
    email = user.email;
    securityState = user.securityLevel;
    getSecurityLevel();
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration:
                    BoxDecoration(color: Colors.blueAccent.withOpacity(0.9)),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                  ),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.91,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            // color: securityColor.withOpacity(0.5),
                            ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.account_circle,
                                  size: 80,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Provider.of<User>(context).nickname,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1, horizontal: 4),
                                      decoration: BoxDecoration(
                                        color: securityColor.withOpacity(0.8),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          securityIcon,
                                          Text(
                                            '보안 Lv. ${Provider.of<User>(context).securityLevel} ',
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
                          ],
                        ),
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
                                    '보유 매장 개수',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    '${Provider.of<StoreProvider>(context).storeList.length}개',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 30),
                                  ),
                                ],
                              ),
                            ),
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
                                        fontWeight: FontWeight.w800,
                                        fontSize: 30),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                // CustomInfoButton(
                                //   buttonText: '회원정보 수정',
                                //   parentContext: context,
                                //   route: Routes.registerUser,
                                //   icon: Icons.manage_accounts,
                                // ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, Routes.identityVerification,
                                        arguments: 2);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.withOpacity(0.2),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    height: 85,
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.manage_accounts,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(
                                              width: 25,
                                            ),
                                            Text('회원정보 수정'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
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
                                  route: Routes.payInfo,
                                  icon: Icons.credit_card,
                                ),
                                CustomInfoButton(
                                  buttonText: '2차 비밀번호',
                                  parentContext: context,
                                  route: Routes.secondaryPassword,
                                  icon: Icons.password_rounded,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('회원탈퇴'),
                                            content: const Text(
                                                '회원탈퇴를 하시겠습니까?\n (탈퇴 후 계정 복구가 불가능합니다.)'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text(
                                                  '취소',
                                                  style: TextStyle(
                                                      color: Colors.blueAccent),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  await UserService
                                                      .deleteUserInfo(
                                                    context: context,
                                                    userId: Provider.of<
                                                                UserProvider>(
                                                            context,
                                                            listen: false)
                                                        .user
                                                        .id!,
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.blueAccent,
                                                ),
                                                child: const Text(
                                                  '확인',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: const Text(
                                    '회원탈퇴',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('로그아웃'),
                                            content: const Text('로그아웃 하시겠습니까?'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text(
                                                  '취소',
                                                  style: TextStyle(
                                                      color: Colors.blueAccent),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  await UserService
                                                      .logoutAction(
                                                          context: context);
                                                  logoutAction();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.blueAccent,
                                                ),
                                                child: const Text(
                                                  '확인',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: const Text(
                                    '로그아웃',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
