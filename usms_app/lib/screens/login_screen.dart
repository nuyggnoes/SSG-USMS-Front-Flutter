import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:usms_app/screens/home_screen.dart';
import 'package:usms_app/routes.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:usms_app/services/user_service.dart';

import 'package:usms_app/widget/my_checkbox.dart';

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
      print("자동로그인!");
      if (mounted) {
        Navigator.pushNamed(context, Routes.home);
      }
    } else {
      print('로그인이 필요합니다');
    }
  }

  // loginAction({
  //   required String username,
  //   required String password,
  //   required bool autoLogin,
  // }) async {
  //   Response response;
  //   var baseoptions = BaseOptions(
  //     headers: {
  //       'Content-Type': 'application/json; charset=utf-8',
  //       'accessToken': 'fake_token',
  //     },
  //     baseUrl: "http://10.0.2.2:3003",
  //   );
  //   Dio dio = Dio(baseoptions);

  //   // dio.interceptors.add(CustomInterceptor(storage: storage));

  //   var param = {
  //     'username': username,
  //     'password': password,
  //   };
  //   try {
  //     response = await dio.post('/login', data: param);
  //     if (response.statusCode == 200) {
  //       print('====================response 200=====================');
  //       var JSESSIONID = response.headers['cookie']?.first ?? '';
  //       // jsessionid를 cookie:value로 저장

  //       // var val = jsonEncode(user.toJson());
  //       await storage.write(
  //         key: 'cookie',
  //         value: username,
  //       );
  //       if (autoLogin) {
  //         await storage.write(
  //           key: 'auto_login',
  //           value: username,
  //         );
  //       }
  //       successLogin();
  //     }
  //   } on DioException catch (e) {
  //     if (e.response?.statusCode == 400) {
  //       print("[Error] : [$e]");
  //       Future.microtask(() {
  //         _showErrorDialog('아이디와 비밀번호가 일치하지 않습니다.', context);
  //       });
  //     }
  //   } on SocketException catch (e) {
  //     print("[Server ERR] : $e");
  //     Future.microtask(() {
  //       _showErrorDialog('서버에 연결할 수 없습니다. 나중에 다시 시도해주세요.', context);
  //     });
  //   } catch (e) {
  //     print("[Error] : [$e]");
  //     Future.microtask(() {
  //       _showErrorDialog('알 수 없는 오류가 발생했습니다.', context);
  //     });
  //   }
  // }

  // successLogin() {
  //   Navigator.pushNamed(context, Routes.home);
  // }

  void _showErrorDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('오류'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _idTextEditController.dispose();
    _passwordTextEditController.dispose();
    super.dispose();
  }

  bool _AutoLoginChecked = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.grey,
        inputDecorationTheme: InputDecorationTheme(
          labelStyle:
              TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 15),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            borderSide: BorderSide(
              width: 2,
              color: Colors.blueAccent,
            ),
          ),
        ),
      ),
      home: GestureDetector(
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
                                controller: _idTextEditController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  labelText: '아이디',
                                  helperText: "",
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
                                controller: _passwordTextEditController,
                                obscureText: true,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  labelText: '비밀번호',
                                  helperText: "",
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
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    userService.loginAction(
                                      username: _idTextEditController.text,
                                      password:
                                          _passwordTextEditController.text,
                                      autoLogin: _AutoLoginChecked,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: Checkbox(
                                        value: _AutoLoginChecked,
                                        onChanged: (value) {
                                          setState(() {
                                            _AutoLoginChecked = value!;
                                          });
                                        },
                                      ),
                                    ),
                                    const Text(
                                      '자동 로그인',
                                      style: TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                const MyCheckBox(
                                  checkboxText: '아이디 저장',
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
                            print('아이디 찾기');
                            Navigator.pushNamed(
                                context, Routes.identityVerification);
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
                            print('비밀번호 찾기');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            '비밀번호 찾기',
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
                                context, Routes.identityVerification);
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
