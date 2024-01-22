import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:usms_app/main.dart';
import 'package:usms_app/models/cctv_model.dart';

class CCTVService {
  static const baseUrl = MyApp.url;
  static const storage = FlutterSecureStorage();

  Future<List<CCTV>?> getAllcctvList({
    required int storeId,
    required int uid,
  }) async {
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
      response = await dio.get('/api/users/$uid/stores/$storeId/cctvs');
      if (response.statusCode == 200) {
        // print(
        //     '====================StoreGetService response 200=====================');
        // List<Mape<String, dynamic>> stores
        List<CCTV> cctvList = CCTV.fromMapToCCTVModel(response.data);
        return cctvList;
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
