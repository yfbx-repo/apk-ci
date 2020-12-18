import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

import 'ding.dart';

///
///上传到蒲公英并发送钉钉消息
///
Future publish(FileSystemEntity apk, String msg) async {
  final map = await upload2Pgy(apk, msg);
  final apkName = path.basename(apk.path);
  final qrcode = map['appQRCodeURL'] as String;
  final shortUrl = map['appShortcutUrl'] as String;
  final apkUrl = 'https://www.pgyer.com/$shortUrl';
  postDing(buildMarkdown(qrcode, apkName, apkUrl, msg));
}

///
///上传到蒲公英
///
Future<Map> upload2Pgy(FileSystemEntity apk, String msg) async {
  final url = 'https://upload.pgyer.com/apiv1/app/upload';

  final apkName = path.basename(apk.path);
  final filePart = await MultipartFile.fromFile(apk.path, filename: apkName);
  final formData = FormData.fromMap({
    'uKey': 'f94f98b0b679b3c0dc92d6bb992669dd',
    '_api_key': '0f83d3377d21ca08f94d96b413dfeae2',
    'installType': 1,
    'updateDescription': msg,
    'file': filePart,
  });

  try {
    final result = await Dio().post(url, data: formData);
    print(result);
    final map = parseJson(result.toString());
    map['ok'] = true;
    return map;
  } on Exception catch (e) {
    print('APK上传失败:$e');
    return {'ok': false};
  }
}

Map parseJson(json) {
  final map = {};
  JsonDecoder((Object key, Object value) {
    map[key] = value;
    return value;
  }).convert(json);
  return map;
}
