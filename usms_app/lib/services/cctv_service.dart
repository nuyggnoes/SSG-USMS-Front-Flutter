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
    required BuildContext context,
    required int storeId,
    required int uid,
  }) async {
    var jSessionId = await storage.read(key: 'cookie');
    print(jSessionId);

    Response response;
    var baseoptions = BaseOptions(
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'cookie': jSessionId,
      },
      baseUrl: baseUrl,
    );
    Dio dio = Dio(baseoptions);

    // try {
    //   response = await dio.get('/api/users/$uid/stores/$storeId/cctvs');
    //   if (response.statusCode == 200) {
    //     // print(
    //     //     '====================StoreGetService response 200=====================');
    //     // List<Mape<String, dynamic>> stores
    //     List<CCTV> cctvList = CCTV.fromMapToCCTVModel(response.data);
    //     return cctvList;
    //   }
    // } on DioException catch (e) {
    //   if (e.response?.statusCode == 400) {
    //     // print("[Error] : [$e]");
    //     // Future.microtask(() {
    //     //   _showErrorDialog('아이디와 비밀번호가 일치하지 않습니다.', context);
    //     // });
    //     return null;
    //   } else {
    //     // Future.microtask(() {
    //     //   customShowDialog(
    //     //       context: context,
    //     //       title: '서버 오류',
    //     //       message: 'CCTV 정보를 불러오는데 실패하였습니다.',
    //     //       onPressed: () {
    //     //         Navigator.pop(context);
    //     //       });
    //     // });
    //     print('서버 오류');
    //   }
    // }
    return null;
  }

  // CCTV 생성
  registerCCTV({
    required BuildContext context,
    required int storeId,
    required int uid,
    required String name,
  }) async {
    print('매장id: $storeId, 유저id: $uid, CCTV별칭: $name');

    var jSessionId = await storage.read(key: 'cookie');
    Response response;
    var baseoptions = BaseOptions(
      headers: {
        "Content-Type": "application/json; charset=utf-8",
        "cookie": jSessionId,
      },
      baseUrl: baseUrl,
    );
    var body = {
      'name': name,
    };
    print('$baseUrl/api/users/$uid/stores/$storeId/cctvs');

    Dio dio = Dio(baseoptions);
    try {
      response =
          await dio.post('/api/users/$uid/stores/$storeId/cctvs', data: body);
      if (response.statusCode! ~/ 100 == 2) {
        print('====================requestStore 200=====================');
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: 'CCTV 생성 성공',
              message: 'CCTV 생성에 성공하였습니다.',
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/home'));
              });
        });
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        print('cctv 생성 오류 ${e.response}');
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '',
              message: '${e.response}',
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              });
        });
      } else {
        Future.microtask(() {
          print('cctv 생성 오류 $e');
          customShowDialog(
              context: context,
              title: '서버 오류',
              // message:
              //     'CCTV 명 : $name\n StoreId : $storeId\n UserId : $uid \n ${e.message}',
              message: '$e',
              onPressed: () {
                Navigator.pop(context);
              });
        });
      }
    }
  }
}
