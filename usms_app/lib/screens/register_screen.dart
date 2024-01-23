import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:usms_app/models/user_model.dart';

import 'package:usms_app/services/user_service.dart';
import 'package:usms_app/widget/custom_textFormField.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.data,
    required this.flag,
    required this.routeCode,
  });
  static const route = 'register-user';
  final String data;
  final bool? flag;
  final bool routeCode;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final UserService userService = UserService();

  late String buttonName;

  late User user;
  final _formKey = GlobalKey<FormState>();
  bool isVerificationVisible = false;
  bool isPasswordValid = false;

  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final TextEditingController _phoneTextEditController =
      TextEditingController();
  final TextEditingController _emailTextEditController =
      TextEditingController();
  final _passwordTextEditController = TextEditingController();
  final _checkPasswordTextEditController = TextEditingController();

  final storage = const FlutterSecureStorage();

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value)
        ? '이메일 형식에 맞지 않습니다.'
        : null;
  }

  getUserInfo() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    final jsonString = await storage.read(key: 'userInfo');
    if (jsonString != null) {
      // 역직렬화
      final Map<String, dynamic> userMap = jsonDecode(jsonString);

      // 사용자 정보로 변환
      User user = User.fromMap(userMap);
      // 이제 user를 사용할 수 있음
      _nameController.text = user.person_name;
      _phoneTextEditController.text = user.phone_number;
      _usernameController.text = user.username;
      _emailTextEditController.text = user.email;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.routeCode == true && widget.flag != null) {
      _phoneTextEditController.text = widget.flag! ? widget.data : '';
      _emailTextEditController.text = widget.flag! ? '' : widget.data;
      buttonName = '회원가입';
    } else if (widget.routeCode == false && widget.flag == null) {
      getUserInfo();
      buttonName = '수정';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _phoneTextEditController.dispose();
    _emailTextEditController.dispose();
    _passwordTextEditController.dispose();
    _checkPasswordTextEditController.dispose();
    super.dispose();
  }

  _pagePopAction() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  requestRegister(User user) async {
    print(user.toJson());
    Response response;
    var jwtToken = await storage.read(key: 'Authorization');
    var baseoptions = BaseOptions(
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $jwtToken',
      },
      baseUrl: "http://10.0.2.2:3003",
    );
    Dio dio = Dio(baseoptions);
    // try {
    //   response = await dio.post('/api/identification', data: user.toJson());

    //   if (response.statusCode == 200) {
    //     // 회원가입 성공시
    //     // 1. 로그인 화면으로
    //     _pagePopAction();
    //     // 2. 메인화면으로
    //   }
    // } on DioException catch (e) {
    //   if (e.response?.statusCode == 400) {
    //     print("[ERROR] : [$e]");
    //     // 400 에러의 body
    //     print('[ERR Body] : ${e.response?.data}');

    //     var errorCode = e.response?.data['code'];
    //     // _showDialog('인증번호 발송 실패', e.response!.data['message'], 0);
    //     if (mounted) {
    //       CustomDialog.showPopDialog(
    //           context, '회원가입 실패', e.response!.data['message'], null);
    //     }
    //     return false;
    //   } else if (e.response?.statusCode == null) {
    //     print('여기다!');
    //     if (mounted) {
    //       CustomDialog.showPopDialog(
    //           context, '서버 오류', '서버에 문제가 발생했습니다. 나중에 다시 시도해 주세요.', null);
    //     }
    //   }
    // } on SocketException catch (e) {
    //   print('[ERR] : ${e.message}');
    // }
    _pagePopAction();
  }

  bool helper = false;
  String? _passwordMatchError;

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
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            elevation: 2,
            title: widget.routeCode ? const Text("회원가입") : const Text("회원정보수정"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 100, horizontal: 25),
              child: Center(
                child: SizedBox(
                  width: 400,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFormField(
                          labelText: '이름',
                          textController: _nameController,
                          textType: TextInputType.text,
                          validator: (String? value) {
                            if (value?.isEmpty ?? true) {
                              return '이름을 입력해주세요!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          labelText: '휴대폰 번호',
                          isEnabled:
                              widget.flag == false || widget.flag == null,
                          counterText: '',
                          maxLength: 11,
                          textController: _phoneTextEditController,
                          textType: TextInputType.number,
                          validator: (String? value) {
                            if (value?.isEmpty ?? true) {
                              return '휴대폰 번호를 입력해주세요!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        CustomTextFormField(
                          labelText: '아이디',
                          maxLength: 20,
                          isEnabled: widget.routeCode,
                          counterText: '',
                          textController: _usernameController,
                          textType: TextInputType.text,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return '아이디를 입력해주세요!';
                            }
                            if (value!.length < 5) {
                              return '아이디는 최소 5자 이상 최대 20자 이하입니다.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          labelText: '이메일',
                          isEnabled: widget.flag == true || widget.flag == null,
                          counterText: '',
                          textController: _emailTextEditController,
                          textType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return '이메일을 입력해주세요!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          labelText: '비밀번호',
                          maxLength: 30,
                          counterText: '',
                          isObcureText: true,
                          textController: _passwordTextEditController,
                          textType: TextInputType.text,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return '비밀번호를 입력해주세요!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          labelText: '비밀번호 확인',
                          maxLength: 30,
                          counterText: '',
                          isObcureText: true,
                          textController: _checkPasswordTextEditController,
                          onChange: (value) {
                            if (value != _passwordTextEditController.text) {
                              setState(() {
                                _passwordMatchError = '비밀번호가 일치하지 않습니다!';
                              });
                            } else {
                              setState(() {
                                _passwordMatchError = null;
                              });
                            }
                          },
                          textType: TextInputType.text,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return '비밀번호를 한 번 더 입력해주세요!';
                            }
                            return _passwordMatchError;
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                print('회원가입버튼');
                                user = User(
                                  username: _usernameController.text,
                                  password: _passwordTextEditController.text,
                                  email: _emailTextEditController.text,
                                  person_name: _nameController.text,
                                  phone_number: _phoneTextEditController.text,
                                  security_state: 0,
                                  is_lock: false,
                                );
                                // requestRegister(user);
                                if (widget.flag != null) {
                                  userService.requestRegister(
                                      context: context,
                                      user: user,
                                      onPressed: _pagePopAction);
                                } else {
                                  // userService.editUserInfo(
                                  //     context: context, user: user);
                                }
                              }
                              // FlutterLocalNotification.showNotification();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                            ),
                            child: Text(
                              buttonName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
