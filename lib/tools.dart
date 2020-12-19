import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

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
  final configs = loadConfigs();
  final url = 'https://upload.pgyer.com/apiv1/app/upload';

  final apkName = path.basename(apk.path);
  final filePart = await MultipartFile.fromFile(apk.path, filename: apkName);
  final formData = FormData.fromMap({
    'uKey': configs['userKey'],
    '_api_key': configs['apiKey'],
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

///
///钉钉消息内容
///
String buildMarkdown(
  String qrcode,
  String apkName,
  String apkUrl,
  String msg,
) {
  return '''
  ![](${qrcode})    
  下载链接：[$apkName]($apkUrl)    
  更新内容：$msg    
  ''';
}

///
///发送消息到钉钉
///
void postDing(String markdown) async {
  final params = {
    'msgtype': 'markdown',
    'markdown': {
      'title': 'Android APK',
      'text': markdown,
    }
  };

  final token = loadConfigs()['token'];
  final client = HttpClient();
  final url = 'https://oapi.dingtalk.com/robot/send?access_token=$token';
  final request = await client.postUrl(Uri.parse(url));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(params)));
  final response = await request.close();
  final responseBody = await response.transform(utf8.decoder).join();
  print(responseBody.toString());
}

///
///从local.properties 中加载配置
///userKey    蒲公英userKey
///apiKey     蒲公英apiKey
///token      钉钉机器人token
///
Map<String, String> loadConfigs() {
  final file = File('./local.properties');
  final map = <String, String>{};
  if (file.existsSync()) {
    final lines = file.readAsLinesSync();
    lines.forEach((element) {
      final e = element.split('=');
      final key = e[0].trim();
      final value = e[1].trim();
      map[key] = value;
    });
  }
  return map;
}

///
///取参扩展
///
extension Args on ArgResults {
  String getString(String key, {String defaultValue = ''}) {
    final value = this[key];
    return value ?? defaultValue;
  }

  bool getBool(String key, {bool defaultValue = false}) {
    final value = this[key];
    return value ?? defaultValue;
  }
}
