import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:usms_app/models/user_model.dart';
import 'package:usms_app/services/user_service.dart';
import 'package:usms_app/widget/custom_text_form_field.dart';

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

  String buttonName = '수정';

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

  getUserInfo() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    final jsonString = await storage.read(key: 'userInfo');
    if (jsonString != null) {
      // 역직렬화
      final Map<String, dynamic> userMap = jsonDecode(jsonString);

      // 사용자 정보로 변환
      User user = User.fromMap(userMap);
      // 이제 user를 사용할 수 있음
      _nameController.text = user.nickname;
      _phoneTextEditController.text = user.phoneNumber;
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

  String? _passwordMatchError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 25),
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
                      isEnabled: widget.flag == false || widget.flag == null,
                      counterText: '',
                      maxLength: 20,
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
                        if (widget.flag != null) {
                          if (value?.isEmpty ?? true) {
                            return '비밀번호를 입력해주세요!';
                          }
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
                        if (widget.flag != null) {
                          if (value?.isEmpty ?? true) {
                            return '비밀번호를 한 번 더 입력해주세요!';
                          }
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
                            user = User(
                              username: _usernameController.text,
                              password: _passwordTextEditController.text,
                              email: _emailTextEditController.text,
                              nickname: _nameController.text,
                              phoneNumber: _phoneTextEditController.text,
                            );
                            if (widget.flag != null) {
                              // 회원가입 요청
                              userService.requestRegister(
                                  context: context,
                                  user: user,
                                  onPressed: _pagePopAction);
                            } else {
                              user = User(
                                username: _usernameController.text,
                                password: _passwordTextEditController.text,
                                email: _emailTextEditController.text,
                                nickname: _nameController.text,
                                phoneNumber: _phoneTextEditController.text,
                              );
                              // 회원정보 수정 요청
                              userService.editUserInfo(
                                  context: context,
                                  user: user,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  });
                            }
                          }
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
    );
  }
}
