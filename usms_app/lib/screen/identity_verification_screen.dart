import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//screen
import 'package:usms_app/screen/register_screen.dart';
import 'package:usms_app/screen/register_store_screen.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});
  static const route = '/identity-verification';

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _phoneEditController;
  late final TextEditingController _emailEditController;
  bool phoneVerfication = false;
  bool emailVerification = false;

  static const storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _phoneEditController = TextEditingController();
    _emailEditController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _phoneEditController.dispose();
    _emailEditController.dispose();
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
                          _phoneEditController,
                          phoneVerfication,
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
                          _emailEditController,
                          emailVerification,
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RegisterScreen.route);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text(
                    '회원가입하러 가기',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  requestVerification(int code, String value) async {
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
    //   }
    // } on DioException catch (e) {
    //   if (e.response?.statusCode == 400) {
    //     print("[Error] : [$e]");
    //   }
    // }
  }

  Widget _textForm(
    String labelText,
    TextInputType type,
    int code,
    TextEditingController controller,
    bool verification,
    Function(bool) updateVerification,
  ) {
    return Column(
      children: [
        SizedBox(
          height: 70,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
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
                  updateVerification(true);
                  print('[CODE] : $code \n [VALUE] : ${controller.text}');
                  requestVerification(code, controller.text);
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
        verification
            ? SizedBox(
                height: 45,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          hintText: '인증번호 입력',
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
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print('인증버튼');
                        // setState(() {
                        //   phoneVerfication = true;
                        // });
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
              )
            : Container(),
      ],
    );
  }
}
