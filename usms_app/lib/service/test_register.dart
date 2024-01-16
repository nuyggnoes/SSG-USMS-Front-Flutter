import 'package:flutter/material.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        child: Form(
          // key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 70,
                child: TextFormField(
                  // controller: _nameController,
                  maxLength: 21,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    counterText: '',
                    labelText: '이름',
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
                child: TextFormField(
                  // enabled: widget.flag == false || widget.flag == null,
                  // controller: _phoneTextEditController,
                  maxLength: 11,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    counterText: '',
                    labelText: '휴대전화 번호',
                    helperText: '',
                  ),
                  validator: (String? value) {
                    if (value?.isEmpty ?? true) {
                      return '전화번호를 입력해주세요!';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 70,
                child: TextFormField(
                  // enabled: widget.flag ?? false,
                  // controller: _usernameController,
                  maxLength: 20,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    counterText: '',
                    labelText: '아이디',
                    helperText: '',
                  ),
                  validator: (String? value) {
                    if (value?.isEmpty ?? true) {
                      return '아이디를 입력해주세요!';
                    }
                    if (value!.length < 5) {
                      return '아이디는 최소 5자 이상 최대 20자 이하입니다.';
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
                child: TextFormField(
                  // enabled: widget.flag == true || widget.flag == null,
                  // controller: _emailTextEditController,
                  maxLength: 21,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    counterText: '',
                    labelText: '이메일',
                    helperText: '',
                  ),
                  validator: (String? value) {
                    if (value?.isEmpty ?? true) {
                      return '이메일을 입력해주세요!';
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
                child: TextFormField(
                  // controller: _passwordTextEditController,
                  maxLength: 21,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    counterText: '',
                    labelText: '비밀번호',
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
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 70,
                child: TextFormField(
                  // controller: _checkPasswordTextEditController,
                  // onChanged: (value) {
                  //   if (value != _passwordTextEditController.text) {
                  //     setState(() {
                  //       _passwordMatchError = '비밀번호가 일치하지 않습니다!';
                  //     });
                  //   } else {
                  //     setState(() {
                  //       _passwordMatchError = null;
                  //     });
                  //   }
                  // },
                  maxLength: 21,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    counterText: '',
                    labelText: '비밀번호 확인',
                    helperText: '',
                  ),
                  validator: (String? value) {
                    if (value?.isEmpty ?? true) {
                      return '비밀번호를 한 번 더 입력해주세요!';
                    }
                    return '_passwordMatchError';
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // if (_formKey.currentState?.validate() ?? false) {
                    //   print('회원가입버튼');
                    //   user = User(
                    //     username: _usernameController.text,
                    //     password: _passwordTextEditController.text,
                    //     email: _emailTextEditController.text,
                    //     person_name: _nameController.text,
                    //     phone_number: _phoneTextEditController.text,
                    //     security_state: 0,
                    //     is_lock: false,
                    //   );
                    //   requestRegister(user);
                    // }
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
    );
  }
}
