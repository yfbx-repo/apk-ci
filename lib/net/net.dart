import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';

final net = _initNet();

Net _initNet() {
  return Net();
}

class Net {
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
      print('发送失败:\n$e');
      return JSON.nil;
    }
  }
}
