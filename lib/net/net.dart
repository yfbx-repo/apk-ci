import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';

final net = _initNet();

Net _initNet() {
  return Net();
}

class Net {
  ///
  /// get
  ///
  Future<JSON> get(
    String url, {
    Map<String, dynamic> params,
    Map<String, dynamic> headers,
  }) async {
    final options = Options();
    if (headers != null && headers.isNotEmpty) {
      options.headers = headers;
    }

    try {
      final result = await Dio().get(
        url,
        queryParameters: params,
        options: options,
      );
      print(result);
      return JSON.parse(result.toString());
    } on Exception catch (e) {
      print(e);
      return JSON.nil;
    }
  }

  ///
  /// post
  ///
  Future<JSON> post(
    String url, {
    data,
    Map<String, dynamic> headers,
  }) async {
    final options = Options();
    if (headers != null && headers.isNotEmpty) {
      options.headers = headers;
    }

    try {
      final result = await Dio().post(
        url,
        data: data,
        options: options,
      );
      print(result);
      return JSON.parse(result.toString());
    } on Exception catch (e) {
      print(e);
      return JSON.nil;
    }
  }
}
