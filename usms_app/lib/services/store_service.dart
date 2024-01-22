import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:usms_app/main.dart';
import 'package:usms_app/models/store_model.dart';
import 'package:usms_app/models/user_model.dart';
import 'package:usms_app/routes.dart';

class StoreService {
  static const baseUrl = MyApp.url;
  static const storage = FlutterSecureStorage();

  Future<List<Store>?> getUserStoresById(int uid) async {
    var jSessionId = await storage.read(key: 'cookie');

    Response response;
    var baseoptions = BaseOptions(
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'cookie': jSessionId,
      },
      baseUrl: "http://10.0.2.2:3003",
    );
    Dio dio = Dio(baseoptions);

    var param = {
      'offset': 0,
      'size': 10,
    };

    try {
      response = await dio.get('/api/users/$uid/stores', data: param);
      if (response.statusCode == 200) {
        print(
            '====================StoreGetService response 200=====================');
        // List<Mape<String, dynamic>> stores
        List<Store> storeList = Store.fromMapToStoreModel(response.data);
        return storeList;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        print("[Error] : [$e]");
        // Future.microtask(() {
        //   _showErrorDialog('아이디와 비밀번호가 일치하지 않습니다.', context);
        // });
        return null;
      }
    } on SocketException catch (e) {
      print("[Server ERR] : $e");
      // Future.microtask(() {
      //   _showErrorDialog('서버에 연결할 수 없습니다. 나중에 다시 시도해주세요.', context);
      // });
      return null;
    } catch (e) {
      print("[Error] : [$e]");
      // Future.microtask(() {
      //   _showErrorDialog('알 수 없는 오류가 발생했습니다.', context);
      // });
      return null;
    }
    return null;
  }

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
        Navigator.pushNamed(context, Routes.home);
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
}
