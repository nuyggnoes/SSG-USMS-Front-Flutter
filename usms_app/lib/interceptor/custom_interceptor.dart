import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final REFRESH_TOKEN_KEY = '';
  final ACCESS_TOKEN_KEY = '';

  CustomInterceptor({required this.storage});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');
    print('[REQ] [Request Header] ${options.headers}');
    if (options.headers['accessToken'] == 'fake_token') {
      print('[REQ] [ACCESS_TOKEN] ${options.headers['accessToken']}');
      // 헤더 삭제}}
      // options.headers.remove('accessToken');

      // 실제 토큰 대체
      // final token = await storage.read(key: ACCESS_TOKEN_KEY);
      // options.headers.addAll({'authorization': 'Bearer $token'});
    } else {
      print('[REQ] [ACCESS_TOKEN] There is no token');
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = storage.read(key: REFRESH_TOKEN_KEY);

    // if (refreshToken == null) {
    //   return handler.reject(err);
    // }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        final response = await dio.post(
          'http://10.0.2.2:3003/',
          options: Options(
            headers: {'authorization': 'Bearer $refreshToken'},
          ),
        );
        final accessToken = response.data['accessToken'];

        final options = err.requestOptions;

        options.headers.addAll({
          'autorization': 'Bearer $accessToken',
        });
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
        final res = await dio.fetch(options);
        return handler.resolve(res);
      } on DioException catch (e) {
        return handler.reject(e);
      }
    }

    super.onError(err, handler);
  }
}
