import 'package:dio/dio.dart';

class AutorizationUser {
  final code;
  final value;

  AutorizationUser({required this.code, required this.value});

  requestAuthenticationCode() async {
    Response response;
    var baseoptions = BaseOptions(
      baseUrl: 'http://10.0.2.2:3003',
    );
    Dio dio = Dio(baseoptions);

    var param = {
      'code': code,
      'value': value,
    };

    try {
      response = await dio.post('/api/identification', data: param);
      if (response.statusCode == 200) {
        print(response.headers);
      } else if (response.statusCode == 400) {
        print(response.data);
      }
    } catch (e) {}
  }
}
