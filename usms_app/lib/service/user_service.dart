import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:usms_app/main.dart';
import 'package:usms_app/service/routes.dart';

class UserService {
  static const baseUrl = MyApp.url;
  static const storage = FlutterSecureStorage();
  // late final uid;

  logoutAction(Function pagePop) async {
    await storage.delete(key: 'auto_login');
    await storage.delete(key: 'cookie');
    pagePop();
  }

  successLogin(context) {
    Navigator.pushNamed(context, Routes.home);
  }

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
        'accessToken': 'fake_token',
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
        print('====================response 200=====================');
        var JSESSIONID = response.headers['cookie']?.first ?? '';
        // jsessionid를 cookie:value로 저장

        // var val = jsonEncode(user.toJson());
        await storage.write(
          key: 'cookie',
          value: username,
        );
        if (autoLogin) {
          await storage.write(
            key: 'auto_login',
            value: username,
          );
        }
        successLogin(context);
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
}
