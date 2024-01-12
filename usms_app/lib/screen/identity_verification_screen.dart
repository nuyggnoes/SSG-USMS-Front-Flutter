import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//screen
import 'package:usms_app/screen/register_screen.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});
  static const route = '/identity-verification';

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  String _authenticationMethod = "";
  String _code = "";
  bool methodState = true;

  bool phoneVerfication = false;
  bool emailVerification = false;
  final _phoneFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();

  final _focusNode = FocusNode();

  static const storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Identity Verification Screen',
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
            title: const Text('본인 인증'),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TabBar(
                  onTap: (value) {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      phoneVerfication = false;
                      emailVerification = false;
                      methodState = !methodState;
                      print('methodState : $methodState');
                    });
                  },
                  controller: _tabController,
                  indicatorColor: Colors.blueAccent,
                  labelColor: Colors.blueAccent,
                  unselectedLabelColor: Colors.black54,
                  // isScrollable: true,
                  tabs: const <Widget>[
                    Tab(
                      text: "휴대폰 인증",
                    ),
                    Tab(
                      text: "이메일 인증",
                    ),
                  ],
                ),
                Container(
                  height: 400,
                  margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TabBarView(
                    // physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 50,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: _textForm(
                          '휴대폰 번호',
                          TextInputType.number,
                          1,
                          phoneVerfication,
                          _phoneFormKey,
                          (value) {
                            setState(() {
                              phoneVerfication = value;
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 400,
                        margin: const EdgeInsets.symmetric(
                          vertical: 50,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: _textForm(
                          '이메일 주소',
                          TextInputType.emailAddress,
                          0,
                          emailVerification,
                          _emailFormKey,
                          (value) {
                            setState(() {
                              emailVerification = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> getVerificationNumber(int code, String value) async {
    Response response;
    var baseoptions = BaseOptions(
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
      baseUrl: "http://10.0.2.2:3003",
    );
    Dio dio = Dio(baseoptions);

    var param = {
      'code': code,
      'value': value,
    };
    print(param);
    // try {
    //   response = await dio.post('/api/identification', data: param);
    //   if (response.statusCode == 200) {
    //     print('====================response 200=====================');
    //     // header에 있는 임시 key값 추출 후 인증번호를 보낼 때 header에 포함시킴
    //     var authenticationKey = response.headers["x-authenticate-key"];
    //     await storage.write(
    //         key: 'x-authentication-key', value: authenticationKey.toString());
    //     _showDialog('', response.data['message']); // 인증 번호 발송 성공 dialog
    //     return true;
    //   }
    // } on DioException catch (e) {
    //   if (e.response?.statusCode == 400) {
    //     print("[ERROR] : [$e]");
    //     // 400 에러의 body
    //     print('[ERR Body] : ${e.response?.data}');

    //     var errorCode = e.response?.data['code'];

    //     switch (errorCode) {
    //       // 코드 번호 상관없이 Body의 message를 dialog에 띄우는거면 한 줄로 처리해도 되지 않을까
    //       case 605:
    //         // 존재하지 않는 요청 code인 경우
    //         _showDialog('인증번호 발송 실패', e.response!.data['message']);
    //         break;
    //       case 606:
    //         // 요청 code에 부적절한 value 양식일 경우
    //         _showDialog('인증번호 발송 실패', e.response!.data['message']);
    //         break;
    //       case 607:
    //         // value 값이 DB에 저장되지 않은 경우
    //         _showDialog('인증번호 발송 실패', e.response!.data['message']);
    //         break;
    //     }
    //     return false;
    //   }
    // } on SocketException catch (e) {
    //   print("[ERROR] : [$e]");
    // }
    _showDialog('', '인증 번호 발송 성공', 0); // 나중에 삭제
    return true; // 나중에 false로 수정
  }

  requestVerification(String code) async {
    print('[인증번호] : $code');
    var xKey = await storage.read(key: 'x-authenticate-key');
    Response response;
    var baseoptions = BaseOptions(
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'x-authenticate-key': '$xKey',
      },
      baseUrl: "http://10.0.2.2:3003",
    );
    Dio dio = Dio(baseoptions);

    var param = {
      'identificaitonCode': code,
    };
    // try {
    //   response = await dio.get('/api/identification', data: param);
    //   if (response.statusCode == 200) {
    //     print('====================response 200=====================');
    //     var jwtToken = response.headers["Authorization"];
    //     await storage.write(
    //         key: 'Authorization', value: jwtToken.toString()); // 수정 예정
    //     _showDialog('', response.data['message'], 1); // 인증 성공 dialog
    //   }
    // } on DioException catch (e) {
    //   if (e.response?.statusCode == 400) {
    //     print("[ERROR] : [$e]");
    //     // 400 에러의 body
    //     print('[ERR Body] : ${e.response?.data}');
    //     _showDialog('', e.response?.data['message'], 0);
    //   }
    // } on SocketException catch (e) {
    //   print("[ERROR] : [$e]");
    // }
    _showDialog('', '인증 성공', 1); // 나중에 삭제
  }

  // 200 : ok
  // 605 : 존재하지 않는 본인 인증 방식입니다. (code가 0(email) 또는 1(phone)이 아닌 경우)
  // 606 : 선택한 본인 인증 방식에 부적절한 양식입니다. (요청 code에 대해 부적잘한 value 양식인 경우)
  // 607 : 존재하지 않는 값(메일 또는 전화번호)입니다. (value 가 DB에 저장되지 않은 경우)
  // 701 : 알림 전송 중 예외가 발생했습니다. 다시 시도해 주세요. (인증 번호 발송 중 예외가 발생한 경우 / BAD GATEWAY)

  void _showDialog(String title, String message, int code) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Navigator.pop(context);
                _handleOnPressedOptions(context, code);
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  _handleOnPressedOptions(BuildContext context, int code) {
    switch (code) {
      case 0:
        Navigator.pop(context);
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterScreen(
              data: _authenticationMethod,
              flag: methodState,
            ),
          ),
        );
        break;
    }
  }

  Widget _textForm(
    String labelText,
    TextInputType type,
    int code,
    bool verification,
    GlobalKey<FormState> formKey,
    Function(bool) updateVerification,
  ) {
    GlobalKey<FormState> codeForm = GlobalKey<FormState>();
    return Column(
      children: [
        Form(
          key: formKey,
          child: SizedBox(
            height: 70,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: type,
                    decoration: InputDecoration(
                      counterText: '',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                      labelText: labelText,
                      helperText: '',
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '입력값이 없습니다.';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _authenticationMethod = newValue!;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      formKey.currentState!.save();
                      // g.Get.snackbar(
                      //   '인증번호 발송',
                      //   '인증번호가 발송되었습니다.',
                      //   backgroundColor: Colors.white,
                      // );
                      if (await getVerificationNumber(
                          code, _authenticationMethod)) {
                        // _showDialog('', '인증번호가 전송되었습니다.');
                        _focusNode.requestFocus();
                        updateVerification(true);
                      }
                      print(
                          '[CODE] : $code \n [VALUE] : $_authenticationMethod');
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
        ),
        verification
            ? Form(
                key: codeForm,
                child: SizedBox(
                  height: 70,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _focusNode,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                            hintText: '인증번호 입력',
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '입력값이 없습니다.';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _code = newValue!;
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (codeForm.currentState?.validate() ?? false) {
                            codeForm.currentState!.save();
                            requestVerification(_code);
                          }
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        child: Text(
                          '인증',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
