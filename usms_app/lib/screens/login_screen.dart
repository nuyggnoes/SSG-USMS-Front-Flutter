import 'package:flutter/material.dart';
import 'package:usms_app/routes.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:usms_app/services/user_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _idTextEditController = TextEditingController();
  final _passwordTextEditController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  static const storage = FlutterSecureStorage();
  dynamic userInfo = '';

  final UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAutoLogin();
    });
  }

  _checkAutoLogin() async {
    userInfo = await storage.read(key: 'auto_login');

    if (userInfo != null) {
      if (mounted) {
        Navigator.pushNamed(context, Routes.home);
      }
    }
  }

  @override
  void dispose() {
    _idTextEditController.dispose();
    _passwordTextEditController.dispose();
    super.dispose();
  }

  bool autoLoginCheck = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 90,
                      left: 30,
                      right: 30,
                    ),
                    width: 300,
                    height: 391,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 70,
                            child: TextFormField(
                              maxLength: 22,
                              controller: _idTextEditController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                labelText: '아이디',
                                helperText: "",
                                counterText: '',
                              ),
                              validator: (String? value) {
                                if (value?.isEmpty ?? true) {
                                  return '아이디를 입력해주세요!';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 70,
                            child: TextFormField(
                              maxLength: 22,
                              controller: _passwordTextEditController,
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                labelText: '비밀번호',
                                helperText: "",
                                counterText: '',
                              ),
                              validator: (String? value) {
                                if (value?.isEmpty ?? true) {
                                  return '비밀번호를 입력해주세요!';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  userService.loginAction(
                                    username: _idTextEditController.text,
                                    password: _passwordTextEditController.text,
                                    autoLogin: autoLoginCheck,
                                    context: context,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                              ),
                              child: const Text(
                                '로그인',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: autoLoginCheck,
                                    onChanged: (value) {
                                      setState(() {
                                        autoLoginCheck = value!;
                                      });
                                    },
                                  ),
                                  const Text(
                                    '자동 로그인',
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, Routes.identityVerification,
                              arguments: 2);
                        },
                        child: const Text(
                          '아이디 찾기 ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(
                        child: Text('|'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, Routes.identityVerification,
                              arguments: 1);
                        },
                        child: const Text(
                          '회원가입',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "© 2024. USMS all rights reserved.",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
