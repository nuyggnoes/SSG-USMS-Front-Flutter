import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:usms_app/main.dart';
import 'package:usms_app/models/store_model.dart';
import 'package:usms_app/services/show_dialog.dart';

class StoreService {
  static const baseUrl = MyApp.url;
  static const storage = FlutterSecureStorage();

  Future<List<Store>?> getUserStoresById(
      {required BuildContext context, required int uid}) async {
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

    var param = {
      'offset': 0,
      'size': 10,
    };

    try {
      response = await dio.get('/api/users/$uid/stores', data: param);
      if (response.statusCode == 200) {
        print('=================StoreGetService response 200=================');
        // List<Mape<String, dynamic>> stores
        List<Store> storeList = Store.fromMapToStoreModel(response.data);
        return storeList;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '로딩 실패',
              message: e.response!.data['message'],
              onPressed: () {
                Navigator.pop(context);
              });
        });
        return null;
      } else {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '서버 오류',
              message: '유저 정보를 불러오는데 실패하였습니다.',
              onPressed: () {
                Navigator.pop(context);
              });
        });
      }
    }
    return null;
  }

  Future<Store?> getStoreInfo(
      {required BuildContext context,
      required int uid,
      required int storeId}) async {
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
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: 'BAD REQUEST',
              message: '${e.response!.data['message']}',
              onPressed: () {
                Navigator.pop(context);
              });
        });
      } else {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '서버 오류',
              message: '매장 정보를 불러오는데 실패하였습니다.',
              onPressed: () {
                Navigator.pop(context);
              });
        });
      }
    }
    return null;
  }
}
