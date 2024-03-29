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
import 'package:usms_app/widget/custom_dialog.dart';
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

    var myToken = await storage.read(key: 'token');
    var baseoptions = BaseOptions(
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
      baseUrl: baseUrl,
    );
    Dio dio = Dio(baseoptions);

    var param = {
      'username': username,
      'password': password,
      'token': myToken,
    };

    try {
      response = await dio.post('/api/login', data: param);
      if (response.statusCode == 200) {
        var setCookieHeader = response.headers['set-cookie']!.first;
        await storage.write(
          key: 'cookie',
          value: setCookieHeader,
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

        Future.microtask(() {
          Navigator.pushNamed(context, Routes.home);
        });
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
              title: '로그인 실패',
              message: '아이디 또는 비밀번호가 일치하지 않습니다.',
              onPressed: () {
                Navigator.pop(context);
              });
        });
      }
    }
  }

  // 로그아웃
  static logoutAction({required BuildContext context}) async {
    var jSessionId = await storage.read(key: 'cookie');

    Response response;

    var baseoptions = BaseOptions(
      headers: {
        "Content-Type": "multipart/form-data;",
        'cookie': jSessionId,
      },
      baseUrl: baseUrl,
    );
    Dio dio = Dio(baseoptions);

    try {
      response = await dio.post(
        '/api/logout',
      );
      if (response.statusCode! ~/ 100 == 2) {
        // loggout
        await storage.delete(key: 'auto_login');
        await storage.delete(key: 'cookie');
        await storage.delete(key: 'userInfo');
        Future.microtask(() {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      }
    } on DioException catch (e) {
      if (e.response!.statusCode! ~/ 100 == 4) {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '로그아웃 실패',
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

  // 유저 정보
  Future<User?> getUserInfo() async {
    final jsonString = await storage.read(key: 'userInfo');
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
        Map<String, List<String>> headers = response.headers.map;

        String authenticateKey =
            headers[AppConstants.xAuthenticateKey]?.first ?? '';

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
      if (e.response!.statusCode! ~/ 100 == 4) {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '인증번호 요청 실패',
              message: e.response!.data['message'],
              onPressed: () {
                Navigator.pop(context);
              });
        });
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
    return false;
  }

  // 인증번호로 본인 인증 시도
  requestVerification({
    required BuildContext context,
    required String data,
    required bool type,
    required bool routeCode,
    required String code,
    required int flagId,
  }) async {
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
        String jwtToken =
            response.headers[AppConstants.jwtAuthorizationKey]?.first ?? '';

        await storage.write(
            key: AppConstants.jwtAuthorizationKey, value: jwtToken);

        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '',
              message: '본인 인증에 성공하였습니다.',
              onPressed: () {
                if (flagId == 1) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterScreen(
                              data: data, flag: type, routeCode: routeCode)),
                      (route) => false);
                } else if (flagId == 2) {
                  findUserId(context: context);
                } else {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, Routes.registerUser);
                }
              });
        });
      }
    } on DioException catch (e) {
      if (e.response!.statusCode! ~/ 100 == 4) {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '본인 인증 실패',
              message: e.response!.data['message'],
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
              Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.login,
                (route) => false,
              );
            },
          );
        });
      }
    } on DioException catch (e) {
      if (e.response!.statusCode! ~/ 100 == 4) {
        Future.microtask(() {
          customShowDialog(
            context: context,
            title: '회원가입 실패',
            message: '${e.response?.data['message']}',
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
  }

  // 회원정보 수정
  editUserInfo({
    required BuildContext context,
    required User user,
    required Function onPressed,
  }) async {
    Response response;
    var jwtToken = await storage.read(key: 'Authorization');
    var baseoptions = BaseOptions(
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': '$jwtToken',
      },
      baseUrl: baseUrl,
    );
    var body = user.toJson();
    if (body['password'] == '') {
      body.remove('password');
    }
    Dio dio = Dio(baseoptions);
    try {
      response = await dio.patch('/api/users/${user.id}', data: body);

      if (response.statusCode == 200) {
        print('회원정보 수정 200');
        Future.microtask(() {
          Provider.of<UserProvider>(context).updateUser(user);
          customShowDialog(
            context: context,
            title: '',
            message: '회원 정보 수정 완료',
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        });
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        print('[ERR Body] : ${e.response?.data}');

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
  }

  // 회원탈퇴
  static deleteUserInfo({
    required BuildContext context,
    required int userId,
  }) async {
    Response response;
    var jSessionId = await storage.read(key: 'cookie');

    var baseoptions = BaseOptions(
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'cookie': jSessionId,
      },
      baseUrl: baseUrl,
    );
    Dio dio = Dio(baseoptions);
    try {
      response = await dio.delete('/api/users/$userId');

      if (response.statusCode! ~/ 100 == 2) {
        Future.microtask(() {
          customShowDialog(
            context: context,
            title: '회원 탈퇴',
            message: '회원 탈퇴가 완료되었습니다.\n 서비스를 이용해주셔서 감사합니다.',
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.login,
                (route) => false,
              );
            },
          );
        });
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        Future.microtask(() {
          customShowDialog(
            context: context,
            title: '회원삭제 실패',
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
  }

  // JWT로 아이디 찾기
  Future<void> findUserId({
    required BuildContext context,
  }) async {
    Response response;
    var jwtToken = await storage.read(key: AppConstants.jwtAuthorizationKey);
    var baseoptions = BaseOptions(
      headers: {
        AppConstants.jwtAuthorizationKey: '$jwtToken',
      },
      baseUrl: baseUrl,
    );
    Dio dio = Dio(baseoptions);
    try {
      response = await dio.get('/api/user');

      if (response.statusCode! ~/ 100 == 2) {
        var idList = User.fromMapToUserModel(response.data);

        Future.microtask(() {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('아이디 찾기'),
                content: SizedBox(
                  width: double.maxFinite,
                  height: 200,
                  child: ListView(
                    children: idList.map(
                      (id) {
                        return ListTile(
                          title: const Text('아이디'),
                          subtitle: Text(id.username),
                        );
                      },
                    ).toList(),
                  ),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text(
                      '로그인하러가기',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              );
            },
            barrierDismissible: false,
          );
        });
      }
    } on DioException catch (e) {
      if (e.response!.statusCode! ~/ 100 == 4) {
        Future.microtask(() {
          customShowDialog(
            context: context,
            title: '본인인증 실패',
            message: '${e.response?.data['message']}',
            onPressed: () {
              Navigator.pop(context);
            },
          );
        });
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
  }
}
