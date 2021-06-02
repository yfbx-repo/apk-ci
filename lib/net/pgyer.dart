import 'dart:io';

import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';
import 'package:path/path.dart' as path;

import '../configs.dart';

final pgyer = _initPgyer();

Pgyer _initPgyer() {
  return Pgyer();
}

class Pgyer {
  ///
  /// 上传APK到蒲公英
  ///
  Future<JSON> upload(FileSystemEntity apk, String msg) async {
    final url = 'https://upload.pgyer.com/apiv1/app/upload';

    final apkName = path.basename(apk.path);
    final filePart = await MultipartFile.fromFile(apk.path, filename: apkName);
    final formData = FormData.fromMap({
      'uKey': configs.userKey,
      '_api_key': configs.apiKey,
      'installType': 1,
      'updateDescription': msg,
      'file': filePart,
    });

    try {
      final result = await Dio().post(url, data: formData);
      print(result);
      return JSON.parse(result.toString());
    } on Exception catch (e) {
      print('APK上传失败:$e');
      return JSON.nil;
    }
  }
}
