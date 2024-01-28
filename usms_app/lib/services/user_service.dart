import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:usms_app/contants/app_constants.dart';

import 'package:usms_app/main.dart';
import 'package:usms_app/models/user_model.dart';
import 'package:usms_app/routes.dart';
import 'package:usms_app/screens/register_screen.dart';
import 'package:usms_app/services/show_dialog.dart';
import 'package:usms_app/utils/user_provider.dart';

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
      // baseUrl: "http://10.0.2.2:3003",
      // baseUrl: "https://127.0.0.1:3003",
      baseUrl: baseUrl,
    );
    Dio dio = Dio(baseoptions);

    // dio.interceptors.add(CustomInterceptor(storage: storage));
    var param = {
      'username': username,
      'password': password,
    };
    try {
      response = await dio.post('/api/login', data: param);
      // response = await dio.post('/login', data: param);
      print(param);
      if (response.statusCode == 200) {
        String? jSessionId;
        print('==============UserService response 200=================');
        print('[response.headers : ${response.headers}]');

        var setCookieHeader = response.headers['set-cookie']!.first;
        print('[set-cookie : $setCookieHeader]');

        print('[RESPONSE DATA] : ${response.data}');
        print('[RESPONSE DATA(User)] : ${response.data["user"]}');
        print('[sessionid] : $jSessionId');
        print('[USERINFO] : ${jsonEncode(response.data)}');
        await storage.write(
          key: 'cookie',
          value: setCookieHeader,
        );
        await storage.write(
          key: 'userInfo',
          value: jsonEncode(response.data["user"]),
        );
        if (autoLogin) {
          await storage.write(
            key: 'auto_login',
            value: username,
          );
        }
        // successLogin(context);
        // Future.microtask(() {
        Navigator.pushNamed(context, Routes.home);
        // });
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '로그인 실패',
              message: '아이디 또는 비밀번호가 일치하지 않습니다.',
              onPressed: () {
                Navigator.pop(context);
              });
        });
      } else if (e.response?.statusCode == 401) {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '2차 비밀번호',
              message: '2차 비밀번호 인증이 필요합니다.',
              onPressed: () {
                Navigator.pushNamed(context, Routes.secondaryPassword);
              });
        });
      } else if (e.response?.statusCode == 429) {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '로그인 실패',
              message: '${e.response?.data['message']}',
              onPressed: () {
                Navigator.pop(context);
              });
        });
      } else {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '서버 오류',
              message: '$e',
              onPressed: () {
                Navigator.pop(context);
              });
        });
      }
    }
  }

  // 로그아웃
  logoutAction(Function pagePop) async {
    await storage.delete(key: 'auto_login');
    await storage.delete(key: 'cookie');
    await storage.delete(key: 'userInfo');
    print('userService.logout()');
    pagePop();
  }

  // 유저 정보
  Future<User?> getUserInfo() async {
    final jsonString = await storage.read(key: 'userInfo');
    print('[유저 정보] : $jsonString');
    User? user;
    if (jsonString != null) {
      final Map<String, dynamic> userMap = jsonDecode(jsonString);
      user = User.fromMap(userMap);
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

    var body = {
      'code': code,
      'value': value,
    };

    try {
      response = await dio.post('/api/identification', data: body);
      if (response.statusCode! ~/ 100 == 2) {
        print('==================== 본인 인증 번호 발송 성공 =====================');
        print('response headers : ${response.headers}');
        Map<String, List<String>> headers = response.headers.map;

        String authenticateKey =
            headers[AppConstants.xAuthenticateKey]?.first ?? '';
        print('인증 키 : $authenticateKey');
        await storage.write(
            key: AppConstants.xAuthenticateKey, value: authenticateKey);

        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '인증번호 발송',
              message: '인증번호가 성공적으로 발송되었습니다.',
              onPressed: () {
                Navigator.pop(context);
              });
        });
        return true;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        // 400 에러의 body
        print('[ERR Body] : ${e.response?.data}');

        var errorCode = e.response?.data['code'];

        switch (errorCode) {
          // 코드 번호 상관없이 Body의 message를 dialog에 띄우는거면 한 줄로 처리해도 되지 않을까
          case 605:
            // 존재하지 않는 요청 code인 경우
            Future.microtask(() {
              customShowDialog(
                  context: context,
                  title: '605 실패',
                  message: e.response!.data['message'],
                  onPressed: () {
                    Navigator.pop(context);
                  });
            });
            break;
          case 606:
            // 요청 code에 부적절한 value 양식일 경우
            Future.microtask(() {
              customShowDialog(
                  context: context,
                  title: '606 실패',
                  message: e.response!.data['message'],
                  onPressed: () {
                    Navigator.pop(context);
                  });
            });
            break;
          case 607:
            // value 값이 DB에 저장되지 않은 경우
            Future.microtask(() {
              customShowDialog(
                  context: context,
                  title: '607 실패',
                  message: e.response!.data['message'],
                  onPressed: () {
                    Navigator.pop(context);
                  });
            });
            break;
        }
        return false;
      } else {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '인증번호 받기 서버 오류',
              message: e.message!,
              onPressed: () {
                Navigator.pop(context);
              });
        });
      }
    }
    return false; // 나중에 false로 수정
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
    var xKey = await storage.read(key: AppConstants.xAuthenticateKey);
    Response response;
    var baseoptions = BaseOptions(
      headers: {
        AppConstants.xAuthenticateKey: '$xKey',
      },
      baseUrl: baseUrl,
    );
    Dio dio = Dio(baseoptions);

    var param = {
      'identificationCode': code,
    };
    try {
      response = await dio.get(
        '/api/identification',
        queryParameters: param,
      );
      if (response.statusCode == 201) {
        print('==================== 인증번호로 본인 인증 성공 =====================');
        print('[response headers ${response.headers}]');
        String jwtToken =
            response.headers[AppConstants.jwtAuthorizationKey]?.first ?? '';
        print('[jwt Token] : $jwtToken');
        await storage.write(
            key: AppConstants.jwtAuthorizationKey, value: jwtToken);

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
                            data: data, flag: type, routeCode: routeCode)),
                    (route) => false);
              });
        });
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        print("[ERROR] : [$e]");
        print('[ERR Body] : ${e.response?.data}');
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '400 오류',
              message: e.message!,
              onPressed: () {
                Navigator.pop(context);
              });
        });
      } else {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '인증번호 입력 서버 오류',
              message: e.message!,
              onPressed: () {
                Navigator.pop(context);
              });
        });
      }
    }
  }

  // 회원가입 요청
  requestRegister({
    required BuildContext context,
    required User user,
    required Function onPressed,
  }) async {
    print(user.toJson());
    Response response;
    var jwtToken = await storage.read(key: AppConstants.jwtAuthorizationKey);
    var baseoptions = BaseOptions(
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        AppConstants.jwtAuthorizationKey: '$jwtToken',
      },
      baseUrl: baseUrl,
    );
    Dio dio = Dio(baseoptions);
    try {
      response = await dio.post('/api/users', data: user.toJson());

      if (response.statusCode! ~/ 100 == 2) {
        Future.microtask(() {
          customShowDialog(
            context: context,
            title: '환영합니다.',
            message: '회원가입 성공',
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          );
        });
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        print("[ERROR] : [$e]");
        // 400 에러의 body
        print('[ERR Body] : ${e.response?.data}');

        var errorCode = e.response?.data['code'];
        Future.microtask(() {
          customShowDialog(
            context: context,
            title: '회원가입 실패',
            message: '${e.response?.data}',
            onPressed: () {
              Navigator.pop(context);
            },
          );
        });
        return false;
      } else {
        Future.microtask(() {
          customShowDialog(
            context: context,
            title: '서버 오류',
            message: '${e.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          );
        });
      }
    }
    // Future.microtask(() {
    //   customShowDialog(
    //       context: context,
    //       title: '환영합니다.',
    //       message: '회원가입 성공',
    //       onPressed: () {
    //         onPressed();
    //       });
    // });
  }

  // 회원정보 수정
  editUserInfo({
    required BuildContext context,
    required User user,
    required Function onPressed,
  }) async {
    print('[회원(id = ${user.id}) 정보 수정] => ${user.toJson()}');
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
    //   response = await dio.patch('/api/users/${user.id}', data: user.toJson());

    //   if (response.statusCode == 200) {
    //     print('회원정보 수정 200');
    //     Future.microtask(() {
    //       // Provider.of<UserProvider>(context).updateUser(user);
    //     });
    //     // Future.microtask(() {
    //     //   customShowDialog(
    //     //     context: context,
    //     //     title: '',
    //     //     message: '회원 정보 수정 완료',
    //     //     onPressed: () {},
    //     //   );
    //     // });
    //   }
    // } on DioException catch (e) {
    //   if (e.response?.statusCode == 400) {
    //     print("[ERROR] : [$e]");
    //     // 400 에러의 body
    //     print('[ERR Body] : ${e.response?.data}');

    //     var errorCode = e.response?.data['code'];
    //     Future.microtask(() {
    //       customShowDialog(
    //         context: context,
    //         title: '회원가입 실패',
    //         message: '${e.response?.data}',
    //         onPressed: () {
    //           Navigator.pop(context);
    //         },
    //       );
    //     });
    //     return false;
    //   } else {
    //     Future.microtask(() {
    //       customShowDialog(
    //         context: context,
    //         title: '서버 오류',
    //         message: '${e.message}',
    //         onPressed: () {
    //           Navigator.pop(context);
    //         },
    //       );
    //     });
    //   }
    // }
  }
}
