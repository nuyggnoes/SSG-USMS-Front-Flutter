import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:usms_app/main.dart';
import 'package:usms_app/models/store_model.dart';

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
        // print(
        //     '====================StoreGetService response 200=====================');
        // List<Mape<String, dynamic>> stores
        List<Store> storeList = Store.fromMapToStoreModel(response.data);
        return storeList;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // print('[ERROR MESSAGE] : ${e.message}');
      }
      if (e.response?.statusCode == 400) {
        // print("[Error] : [$e]");
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

  Future<Store?> getStoreInfo(int uid, int storeId) async {
    var jSessionId = await storage.read(key: 'cookie');

    Response response;
    var baseoptions = BaseOptions(
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'cookie': jSessionId,
      },
      baseUrl: baseUrl,
    );
    Dio dio = Dio(baseoptions);

    try {
      response = await dio.get('/api/users/$uid/stores/$storeId');
      if (response.statusCode == 200) {
        // print(
        //     '====================StoreGetService response 200=====================');
        // List<Mape<String, dynamic>> stores
        Store store = Store.fromMap(response.data);
        return store;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // print('[ERROR MESSAGE] : ${e.message}');
      }
      if (e.response?.statusCode == 400) {
        // print("[Error] : [$e]");
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
}
