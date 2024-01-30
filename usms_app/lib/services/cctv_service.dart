import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:usms_app/main.dart';
import 'package:usms_app/models/cctv_model.dart';
import 'package:usms_app/services/show_dialog.dart';
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
    print(jSessionId);

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
        print('=========GetCCTVsService response 200===========');
        // List<Mape<String, dynamic>> stores
        print(response.data);
        List<CCTV> cctvList = CCTV.fromMapToCCTVModel(response.data);
        return cctvList;
      }
    } on DioException catch (e) {
      if (e.response!.statusCode! ~/ 100 == 4) {
        print("[Error] : [$e]");
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '매장 CCTV 조회 오류',
              message: '${e.response!.data['message']} \n 잠시 후에 다시 시도해주세요.',
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
              message: '${e.response!.data}.',
              onPressed: () {
                Navigator.pop(context);
              });
        });
        print('서버 오류');
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
    print('cctv 생성 post url : $baseUrl/api/users/$uid/stores/$storeId/cctvs');

    Dio dio = Dio(baseoptions);
    try {
      response =
          await dio.post('/api/users/$uid/stores/$storeId/cctvs', data: body);
      if (response.statusCode! ~/ 100 == 2) {
        print('====================cctvRegister 200=====================');
        CCTV newCCTV = CCTV.fromMap(response.data); // 지금은 null값
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
        print('cctv 생성 오류 ${e.response}');
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
          print('cctv 생성 오류 ${e.response}');
          customShowDialog(
              context: context,
              title: '서버 오류',
              // message:
              //     'CCTV 명 : $name\n StoreId : $storeId\n UserId : $uid \n ${e.message}',
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
        print('=============StoreDelete response 200=============');

        // List<Mape<String, dynamic>> stores
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
  // static Future<ChewieController> getCCTVLiveStream({
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
    // "https://usms.serveftp.com/video/hls/live/$streamKey/index.m3u8";
    try {
      response = await dio.get('/video/hls/live/$streamKey/index.m3u8');
      if (response.statusCode! ~/ 100 == 2) {
        print('=============CCTVLive response 200=============');
        print(response.data);
        var m3u8Content = response.data;
        List<String> tsUrls = extractTsUrlsFromM3u8(m3u8Content);
        return tsUrls;

        // List<Mape<String, dynamic>> stores
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

  // cctv 다시보기 조회
  static getCCTVReplay({
    required BuildContext context,
    required CCTV cctv,
    required DateTime date,
    // required int index,
  }) async {
    print('DateTime date : $date');
    print('TimeStamp date : ${date.microsecondsSinceEpoch}');

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
    var timestamp = date.microsecondsSinceEpoch;
    print(timestamp);

    // try {
    //   response = await dio.get(
    //       '/video/hls/replay/${cctv.cctvStreamKey}/${cctv.cctvStreamKey}-{timestamp}.m3u8');
    //   if (response.statusCode! ~/ 100 == 2) {
    //     print('=============CCTVLive response 200=============');
    //     print(response.data);
    //     var m3u8Content = response.data;
    //     List<String> tsUrls = extractTsUrlsFromM3u8(m3u8Content);
    //     return tsUrls;

    //     // List<Mape<String, dynamic>> stores
    //   }
    // } on DioException catch (e) {
    //   if (e.response!.statusCode! ~/ 100 == 4) {
    //     Future.microtask(() {
    //       customShowDialog(
    //           context: context,
    //           title: '실시간 CCTV 조회 실패',
    //           message: '${e.response!.data}',
    //           onPressed: () {
    //             Navigator.pop(context);
    //           });
    //     });
    //     return [];
    //   } else {
    //     Future.microtask(() {
    //       customShowDialog(
    //           context: context,
    //           title: '오류 메시지',
    //           message: '실시간 CCTV 조회 실패 : ${e.response}',
    //           onPressed: () {
    //             Navigator.pop(context);
    //           });
    //     });
    //   }
    // }
  }

  static List<String> extractTsUrlsFromM3u8(String m3u8Content) {
    List<String> tsUrls = [];

    // 각 줄을 분리하여 반복
    List<String> lines = m3u8Content.split('\n');
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();

      // #EXTINF 또는 .ts 파일의 URL 패턴을 확인
      if (line.startsWith('#EXTINF')) {
        // #EXTINF 행의 다음 줄에 .ts 파일의 URL이 있다고 가정
        if (i + 1 < lines.length) {
          String tsUrl = lines[i + 1].trim();
          // tsUrls.add(tsUrl);
        }
      } else if (line.endsWith('.ts')) {
        // .ts 파일의 URL이 바로 해당 줄에 나와 있는 경우
        tsUrls.add(line);
      }
    }

    return tsUrls;
  }
}
