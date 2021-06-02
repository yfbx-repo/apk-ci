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
  Future<JSON> post(String url, Map<String, dynamic> map) async {
    try {
      final result = await Dio().post(url, data: map);
      print(result);
      return JSON.parse(result.toString());
    } on Exception catch (e) {
      print('发送失败:\n$e');
      return JSON.nil;
    }
  }
}
