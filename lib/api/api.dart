import 'package:dio/dio.dart';


class Api {
  Dio _dio = Dio();

  Api() {
     _dio = Dio();
  }

  Future<dynamic> get(String url) async {
    try {
      Response response = await _dio.get(url);
      return response.data;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> post(String url, dynamic data) async {
    try {
      Response response = await _dio.post(url, data: data);
      return response.data;
    } catch (e) {
      throw Exception(e);
    }
  }

}
