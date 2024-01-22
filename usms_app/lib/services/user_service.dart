import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:usms_app/main.dart';
import 'package:usms_app/models/user_model.dart';
import 'package:usms_app/routes.dart';
import 'package:usms_app/screens/register_screen.dart';
import 'package:usms_app/services/show_dialog.dart';

class UserService {
  static const baseUrl = MyApp.url;
  static const storage = FlutterSecureStorage();

  // 로그인
  loginAction({
    required BuildContext context,
    required String username,
    required String password,
    required bool autoLogin,
  }) async {
    Response response;
    var baseoptions = BaseOptions(
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
      baseUrl: "http://10.0.2.2:3003",
    );
    Dio dio = Dio(baseoptions);

    // dio.interceptors.add(CustomInterceptor(storage: storage));

    var param = {
      'username': username,
      'password': password,
    };
    try {
      response = await dio.post('/login', data: param);
      if (response.statusCode == 200) {
        print(
            '====================UserService response 200=====================');
        var JSESSIONID = response.headers['cookie']?.first ?? '';
        // response.data type : Map<String, dynamic>
        // user = User.fromMap(response.data);
        print('[sessionid] : $JSESSIONID');
        await storage.write(
          key: 'cookie',
          value: username,
        );
        await storage.write(
          key: 'userInfo',
          value: jsonEncode(response.data),
        );
        if (autoLogin) {
          await storage.write(
            key: 'auto_login',
            value: username,
          );
        }
        // successLogin(context);
        Future.microtask(() {
          Navigator.pushNamed(context, Routes.home);
        });
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        print("[Error] : [$e]");
        // Future.microtask(() {
        //   _showErrorDialog('아이디와 비밀번호가 일치하지 않습니다.', context);
        // });
      }
    } on SocketException catch (e) {
      print("[Server ERR] : $e");
      // Future.microtask(() {
      //   _showErrorDialog('서버에 연결할 수 없습니다. 나중에 다시 시도해주세요.', context);
      // });
    } catch (e) {
      print("[Error] : [$e]");
      // Future.microtask(() {
      //   _showErrorDialog('알 수 없는 오류가 발생했습니다.', context);
      // });
    }
  }

  // 로그아웃
  logoutAction(Function pagePop) async {
    await storage.delete(key: 'auto_login');
    await storage.delete(key: 'cookie');
    await storage.delete(key: 'userInfo');
    pagePop();
  }

  // 유저 정보
  Future<User?> getUserInfo() async {
    final jsonString = await storage.read(key: 'userInfo');
    User? user;
    if (jsonString != null) {
      // 역직렬화
      final Map<String, dynamic> userMap = jsonDecode(jsonString);
      // 사용자 정보로 변환
      user = User.fromMap(userMap);
      // 이제 user를 사용할 수 있음
    }
    return user;
  }

  // 본인 인증 번호 발송
  Future<bool> getVerificationNumber({
    required BuildContext context,
    required int code,
    required String value,
  }) async {
    Response response;
    var baseoptions = BaseOptions(
      baseUrl: baseUrl,
    );
    Dio dio = Dio(baseoptions);

    var param = {
      'code': code,
      'value': value,
    };
    // try {
    //   response = await dio.post('/api/identification', data: param);
    //   if (response.statusCode == 200) {
    //     print('====================response 200=====================');
    //     // header에 있는 임시 key값 추출 후 인증번호를 보낼 때 header에 포함시킴
    //     Map<String, List<String>> headers = response.headers.map;
    //     String authenticationKey = headers['x-authentication-key']?.first ?? '';
    //     await storage.write(
    //         key: 'x-authentication-key', value: authenticationKey.toString());
    //     _showDialog('', response.data['message'], 0); // 인증 번호 발송 성공 dialog
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
    //         _showDialog('인증번호 발송 실패', e.response!.data['message'], 0);
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
    // _showDialog('', '인증 번호 발송 성공', 0); // 나중에 삭제
    // CustomDialog.showPopDialog(context, '', '인증 번호 발송 성공', null);
    customShowDialog(
        context: context,
        title: '',
        message: '인증 번호 발송 성공',
        onPressed: () {
          Navigator.pop(context);
        });
    return true; // 나중에 false로 수정
  }

  // 인증번호로 본인 인증 시도
  requestVerification({
    required BuildContext context,
    required String data,
    required bool type,
    required bool routeCode,
    required String code,
  }) async {
    print('[인증번호] : $code');
    var xKey = await storage.read(key: 'x-authenticate-key');
    Response response;
    var baseoptions = BaseOptions(
      headers: {
        'x-authenticate-key': '$xKey',
      },
      baseUrl: baseUrl,
    );
    Dio dio = Dio(baseoptions);

    var param = {
      'identificaitonCode': code,
    };
    // try {
    //   response = await dio.get('/api/identification', data: param);
    //   if (response.statusCode == 200) {
    //     print('====================response 200=====================');
    //     String jwtToken = response.headers['Authorization']?.first ?? '';
    //     await storage.write(key: 'Authorization', value: jwtToken);
    //     // _showDialog('', response.data['message'], 1);
    //     customShowDialog(
    //         context: context,
    //         title: '',
    //         message: '본인 인증 성공',
    //         onPressed: () {
    //           Navigator.pushAndRemoveUntil(
    //               context,
    //               MaterialPageRoute(
    //                   builder: (context) => const RegisterScreen(
    //                       data: '', flag: null, routeCode: true)),
    //               (route) => false);
    //         });
    //   }
    // } on DioException catch (e) {
    //   if (e.response?.statusCode == 400) {
    //     print("[ERROR] : [$e]");
    //     // 400 에러의 body
    //     print('[ERR Body] : ${e.response?.data}');
    //     // _showDialog('', e.response?.data['message'], 0);
    //   }
    // } on SocketException catch (e) {
    //   print("[ERROR] : [$e]");
    // }
    // _showDialog('', '인증 성공', 1); // 나중에 삭제
    Future.microtask(() {
      customShowDialog(
          context: context,
          title: '',
          message: '본인 인증 성공',
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterScreen(
                    data: data, flag: type, routeCode: routeCode),
              ),
              ModalRoute.withName('/'),
            );
          });
    });
    // routecode true and flag != null
    // flag = true : phone
    // flag = false : email
  }

  // 회원가입 요청
  requestRegister({
    required BuildContext context,
    required User user,
  }) async {
    print(user.toJson());
    Response response;
    var jwtToken = await storage.read(key: 'Authorization');
    var baseoptions = BaseOptions(
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $jwtToken',
      },
      baseUrl: baseUrl,
    );
    Dio dio = Dio(baseoptions);
    // try {
    //   response = await dio.post('/api/users', data: user.toJson());

    //   if (response.statusCode == 200) {
    //     customShowDialog(
    //         context: context,
    //         title: '환영합니다.',
    //         message: '회원가입 성공',
    //         onPressed: () {
    //           Navigator.popUntil(context, ModalRoute.withName('/'));
    //         });
    //   }
    // } on DioException catch (e) {
    //   if (e.response?.statusCode == 400) {
    //     print("[ERROR] : [$e]");
    //     // 400 에러의 body
    //     print('[ERR Body] : ${e.response?.data}');

    //     var errorCode = e.response?.data['code'];
    //     // _showDialog('인증번호 발송 실패', e.response!.data['message'], 0);
    //     // if (mounted) {
    //     //   CustomDialog.showPopDialog(
    //     //       context, '회원가입 실패', e.response!.data['message'], null);
    //     // }
    //     return false;
    //   } else if (e.response?.statusCode == null) {
    //     print('여기다!');
    //     // if (mounted) {
    //     //   CustomDialog.showPopDialog(
    //     //       context, '서버 오류', '서버에 문제가 발생했습니다. 나중에 다시 시도해 주세요.', null);
    //     // }
    //   }
    // } on SocketException catch (e) {
    //   print('[ERR] : ${e.message}');
    // }
    Future.microtask(() {
      customShowDialog(
          context: context,
          title: '환영합니다.',
          message: '회원가입 성공',
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          });
    });
  }
}