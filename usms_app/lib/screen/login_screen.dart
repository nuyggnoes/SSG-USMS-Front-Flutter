import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:usms_app/interceptor/custom_interceptor.dart';

import 'package:usms_app/models/user_model.dart';
import 'package:usms_app/screen/home_screen.dart';
import 'package:usms_app/screen/identity_verification_screen.dart';
import 'package:usms_app/screen/register_screen.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    userInfo = await storage.read(key: 'auto_login');

    if (userInfo != null) {
      print("자동로그인!");
      Navigator.pushNamed(context, HomeScreen.route);
    } else {
      print('로그인이 필요합니다');
    }
  }

  loginAction(User user, bool autoLogin) async {
    Response response;
    var baseoptions = BaseOptions(
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'accessToken': 'fake_token',
      },
      baseUrl: "http://10.0.2.2:3003",
    );
    Dio dio = Dio(baseoptions);

    // dio.interceptors.add(CustomInterceptor(storage: storage));

    var param = {
      'username': user.username,
      'password': user.password,
    };
    try {
      response = await dio.post('/login', data: param);
      if (response.statusCode == 200) {
        print('====================response 200=====================');
        var val = jsonEncode(user.toJson());
        await storage.write(
          key: 'login',
          value: val,
        );
        if (autoLogin) {
          await storage.write(
            key: 'auto_login',
            value: val,
          );
        }
        Navigator.pushNamed(context, HomeScreen.route);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        print("[Error] : [$e]");
        Future.microtask(() {
          _showErrorDialog('아이디와 비밀번호가 일치하지 않습니다.');
        });
      }
    } on SocketException catch (e) {
      print("[Server ERR] : $e");
      Future.microtask(() {
        _showErrorDialog('서버에 연결할 수 없습니다. 나중에 다시 시도해주세요.');
      });
    } catch (e) {
      print("[Error] : [$e]");
      Future.microtask(() {
        _showErrorDialog('알 수 없는 오류가 발생했습니다.');
      });
    }
  }

  void _showErrorDialog(String message) {
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
                      child: Theme(
                        data: ThemeData(
                          primaryColor: Colors.grey,
                          inputDecorationTheme: InputDecorationTheme(
                            labelStyle: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: 15),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 70,
                              child: TextFormField(
                                controller: _idTextEditController,
                                onChanged: (text) {},
                                keyboardType: TextInputType.emailAddress,
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
                                onChanged: (text) {},
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
                                    loginAction(
                                      User(
                                        username: _idTextEditController.text,
                                        password:
                                            _passwordTextEditController.text,
                                      ),
                                      _AutoLoginChecked,
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
                                          print(
                                              '체크 상태(true면 체크상태) : $_AutoLoginChecked');
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
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          print('아이디 찾기');
                          Navigator.pushNamed(
                              context, VerificationScreen.route);
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
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const VideoScreen(),
                          //   ),
                          // );
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
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const RegisterScreen(),
                          //     // fullscreenDialog: true, // true : bottom
                          //   ),
                          // );
                          Navigator.pushNamed(
                              context, VerificationScreen.route);
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
    );
  }
}
