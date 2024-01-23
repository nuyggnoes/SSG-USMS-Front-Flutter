import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:usms_app/main.dart';
import 'package:usms_app/models/cctv_model.dart';
import 'package:usms_app/services/show_dialog.dart';

class CCTVService {
  static const baseUrl = MyApp.url;
  static const storage = FlutterSecureStorage();

  // 특정 매장 전체 CCTV 조회
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

  // CCTV 생성
  registerCCTV({
    required BuildContext context,
    required int storeId,
    required int uid,
    required String name,
  }) async {
    print('$storeId, $uid, $name');
    Response response;
    var baseoptions = BaseOptions(
      headers: {"Content-Type": "multipart/form-data;"},
      baseUrl: baseUrl,
    );

    Dio dio = Dio(baseoptions);
    // try {
    //   final response = await dio.post('/api/users/$uid/stores', data: formData);
    //   if (response.statusCode == 200) {
    //     print('====================requestStore 200=====================');
    //     Future.microtask(() {
    //       customShowDialog(
    //           context: context,
    //           title: '매장 생성 성공',
    //           message: '매장 생성에 성공하였습니다.',
    //           onPressed: () {
    //             Navigator.popUntil(context, ModalRoute.withName('/home'));
    //           });
    //     });
    //   }
    // } on DioException catch (e) {
    //   if (e.response?.statusCode == 400) {
    //     Future.microtask(() {
    //       customShowDialog(
    //           context: context,
    //           title: '매장 생성 오류',
    //           message: '${e.response?.data['message']}',
    //           onPressed: () {
    //             Navigator.pop(context);
    //           });
    //     });
    //   } else {
    //     Future.microtask(() {
    //       customShowDialog(
    //           context: context,
    //           title: '서버 오류',
    //           message: '${e.message}',
    //           onPressed: () {
    //             Navigator.pop(context);
    //           });
    //     });
    //   }
    // }
    Future.microtask(() {
      customShowDialog(
          context: context,
          title: 'CCTV 추가',
          message: 'CCTV를 추가하였습니다.',
          onPressed: () {
            // Navigator.pop(context);
          });
    });
  }
}
