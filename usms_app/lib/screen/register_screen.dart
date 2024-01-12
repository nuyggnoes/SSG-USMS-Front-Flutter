import 'package:flutter/material.dart';
import 'package:usms_app/service/register_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.data,
    required this.flag,
  });
  static const route = 'register-user';
  final String data;
  final bool flag;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameFormKey = GlobalKey<FormState>();
  final _idFormKey = GlobalKey<FormState>();

  bool isVerificationVisible = false;
  bool isPasswordValid = false;

  final TextEditingController _phoneTextEditController =
      TextEditingController();
  final TextEditingController _emailTextEditController =
      TextEditingController();
  final _passwordTextEditController = TextEditingController();
  final _checkPasswordTextEditController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    _phoneTextEditController.text = widget.flag ? widget.data : '';
    _emailTextEditController.text = widget.flag ? '' : widget.data;
  }

  @override
  void dispose() {
    _passwordTextEditController.dispose();
    _checkPasswordTextEditController.dispose();
    super.dispose();
  }

  bool helper = false;
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 2,
            title: const Text("회원가입"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 100, horizontal: 25),
              child: Center(
                child: Column(
                  children: [
                    Form(
                      key: _nameFormKey,
                      child: Theme(
                        data: ThemeData(
                          primaryColor: Colors.grey,
                          inputDecorationTheme: InputDecorationTheme(
                            labelStyle: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: 15),
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
                        child: SizedBox(
                          width: 400,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 70,
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    hintText: '이름',
                                    helperText: '',
                                  ),
                                  validator: (String? value) {
                                    if (value?.isEmpty ?? true) {
                                      return '이름을 입력해주세요!';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 70,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        enabled: widget.flag ? false : true,
                                        controller: _phoneTextEditController,
                                        maxLength: 11,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          counterText: '',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              bottomLeft: Radius.circular(12),
                                            ),
                                          ),
                                          labelText: '휴대전화 번호',
                                          helperText: '',
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              bottomLeft: Radius.circular(12),
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                        ),
                                        validator: (String? value) {
                                          if (value?.isEmpty ?? true) {
                                            return '전화번호를 입력해주세요!';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (_nameFormKey.currentState
                                                ?.validate() ??
                                            false) {
                                          setState(() {
                                            print('인증번호받기');
                                            isVerificationVisible = true;
                                          });
                                          var authoInfo = AutorizationUser(
                                            code: 1,
                                            value:
                                                _phoneTextEditController.text,
                                          );
                                          var res = authoInfo
                                              .requestAuthenticationCode();
                                        }
                                      },
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                          const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        '인증번호 받기',
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              isVerificationVisible
                                  ? SizedBox(
                                      height: 45,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              keyboardType: TextInputType.text,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(12),
                                                    bottomLeft:
                                                        Radius.circular(12),
                                                  ),
                                                ),
                                                hintText: '인증번호 입력',
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(12),
                                                    bottomLeft:
                                                        Radius.circular(12),
                                                  ),
                                                  borderSide: BorderSide(
                                                    color: Colors.blueAccent,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              print('인증버튼');
                                              // setState(() {
                                              //   isVerificationVisible = true;
                                              // });
                                            },
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all(
                                                const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(12),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              '인증',
                                              style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              const SizedBox(
                                height: 50,
                              ),
                              //아이디 이메일 비밀번호 Form
                            ],
                          ),
                        ),
                      ),
                    ),
                    Form(
                      key: _idFormKey,
                      child: Theme(
                        data: ThemeData(
                          primaryColor: Colors.grey,
                          inputDecorationTheme: InputDecorationTheme(
                            labelStyle: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: 15),
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
                        child: SizedBox(
                          width: 400,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 70,
                                child: TextFormField(
                                  focusNode: _focusNode,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    hintText: '아이디',
                                    helperText: '',
                                  ),
                                  validator: (String? value) {
                                    if (value?.isEmpty ?? true) {
                                      setState(() {
                                        helper = true;
                                      });
                                      _focusNode.requestFocus();
                                      print(helper);
                                      return '아이디를 입력해주세요!';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 70,
                                child: TextFormField(
                                  enabled: widget.flag ? true : false,
                                  controller: _emailTextEditController,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    hintText: '이메일',
                                    helperText: '',
                                  ),
                                  // validator: (String? value) {
                                  //   if (value?.isEmpty ?? true) {
                                  //     return '이메일을 입력해주세요!';
                                  //   }
                                  //   return null;
                                  // },
                                  validator: validateEmail,
                                ),
                              ),
                              SizedBox(
                                height: 70,
                                child: TextFormField(
                                  controller: _passwordTextEditController,
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    hintText: '비밀번호',
                                    helperText: '',
                                  ),
                                  validator: (String? value) {
                                    if (value?.isEmpty ?? true) {
                                      return '비밀번호를 입력해주세요!';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 70,
                                child: TextFormField(
                                  controller: _checkPasswordTextEditController,
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    hintText: '비밀번호 확인',
                                    helperText: '',
                                  ),
                                  focusNode: FocusNode(
                                    onKeyEvent: (node, event) {
                                      print('hi');
                                      return KeyEventResult.ignored;
                                    },
                                  ),
                                ),
                              ),
                              helper
                                  ? const SizedBox(
                                      child: Text('data'),
                                    )
                                  : Container(),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_idFormKey.currentState?.validate() ??
                                        false) {
                                      print('회원가입버튼');
                                    }
                                    // FlutterLocalNotification.showNotification();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                  ),
                                  child: const Text(
                                    '회원가입',
                                    style: TextStyle(
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
