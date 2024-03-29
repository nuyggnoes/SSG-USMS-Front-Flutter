import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:usms_app/main.dart';
import 'package:usms_app/models/cctv_model.dart';
import 'package:usms_app/widget/custom_dialog.dart';
import 'package:usms_app/utils/cctv_provider.dart';

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

    Response response;
    var baseoptions = BaseOptions(
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'cookie': jSessionId,
      },
      baseUrl: baseUrl,
    );
    var param = {
      "offset": 0,
      "size": 10,
    };
    Dio dio = Dio(baseoptions);

    try {
      response = await dio.get('/api/users/$uid/stores/$storeId/cctvs',
          queryParameters: param);
      if (response.statusCode! ~/ 100 == 2) {
        List<CCTV> cctvList = CCTV.fromMapToCCTVModel(response.data);
        if (cctvList.isEmpty) {
          return null;
        }
        return cctvList;
      }
    } on DioException catch (e) {
      if (e.response!.statusCode! ~/ 100 == 4) {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '매장 CCTV 조회 오류',
              message: '${e.response!.data['message']}',
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
              message: '${e.response!.data}.\n 잠시 후에 다시 시도해주세요',
              onPressed: () {
                Navigator.pop(context);
              });
        });
      }
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

    Dio dio = Dio(baseoptions);
    try {
      response =
          await dio.post('/api/users/$uid/stores/$storeId/cctvs', data: body);
      if (response.statusCode! ~/ 100 == 2) {
        CCTV newCCTV = CCTV.fromMap(response.data);
        Future.microtask(() {
          Provider.of<CCTVProvider>(context, listen: false).addCCTV(newCCTV);
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
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: 'CCTV 생성 오류',
              message: '${e.response}',
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              });
        });
      } else {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '서버 오류',
              message: '${e.response}',
              onPressed: () {
                Navigator.pop(context);
              });
        });
      }
    }
  }

  // cctv 삭제
  static deleteCCTV({
    required BuildContext context,
    required int uid,
    required int storeId,
    required int cctvId,
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
      response =
          await dio.delete('/api/users/$uid/stores/$storeId/cctvs/$cctvId');
      if (response.statusCode! ~/ 100 == 2) {
        Future.microtask(() {
          Provider.of<CCTVProvider>(context, listen: false).removeCCTV(cctvId);
          customShowDialog(
              context: context,
              title: 'CCTV 삭제 완료',
              message: 'CCTV 삭제가 성공적으로 완료되었습니다.',
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              });
        });
      }
    } on DioException catch (e) {
      if (e.response!.statusCode! ~/ 100 == 4) {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: 'CCTV 삭제 ',
              message: '${e.response!.data['message']}',
              onPressed: () {
                Navigator.pop(context);
              });
        });
      } else {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '오류 메시지',
              message: 'CCTV 삭제 실패 : ${e.response}',
              onPressed: () {
                Navigator.pop(context);
              });
        });
      }
    }
  }

  // 실시간 CCTV 조회
  static Future<List<String>> getCCTVLiveStream({
    required BuildContext context,
    required String streamKey,
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
      response = await dio.get('/video/hls/live/$streamKey/index.m3u8');
      if (response.statusCode! ~/ 100 == 2) {
        return response.data;
      }
    } on DioException catch (e) {
      if (e.response!.statusCode! ~/ 100 == 4) {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '실시간 CCTV 조회 실패',
              message: '${e.response!.data}',
              onPressed: () {
                Navigator.pop(context);
              });
        });
        return [];
      } else {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '오류 메시지',
              message: '실시간 CCTV 조회 실패 : ${e.response}',
              onPressed: () {
                Navigator.pop(context);
              });
        });
      }
    }
    return [];
  }

  // cctv 다시보기 전체 조회
  static getAllCCTVReplay({
    required BuildContext context,
    required int userId,
    required int storeId,
    required CCTV cctv,
    required DateTime date,
    // required int index,
  }) async {
    var ymd = date.toString().split(" ").first;

    var jSessionId = await storage.read(key: 'cookie');
    Response response;

    var baseoptions = BaseOptions(
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'cookie': jSessionId,
      },
      baseUrl: baseUrl,
    );

    var param = {
      'date': ymd,
    };
    Dio dio = Dio(baseoptions);

    try {
      response = await dio.get(
          '/api/users/$userId/stores/$storeId/cctvs/${cctv.cctvId}/replay',
          queryParameters: param);
      if (response.statusCode! ~/ 100 == 2) {
        return response.data;
      }
    } on DioException catch (e) {
      if (e.response!.statusCode! ~/ 100 == 4) {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '실시간 CCTV 조회 실패',
              message: '${e.response!.data}',
              onPressed: () {
                Navigator.pop(context);
              });
        });
        return [];
      } else {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '오류 메시지',
              message: '실시간 CCTV 조회 실패 : ${e.response}',
              onPressed: () {
                Navigator.pop(context);
              });
        });
      }
    }
  }
}
