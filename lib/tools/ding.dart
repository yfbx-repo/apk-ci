import 'dart:convert';
import 'dart:io';

import '../global_configs.dart';

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
  APK：[$apkName]($apkUrl)    
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

  final token = GlobalConfigs.token;
  final client = HttpClient();
  final url = 'https://oapi.dingtalk.com/robot/send?access_token=$token';
  final request = await client.postUrl(Uri.parse(url));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(params)));
  final response = await request.close();
  final responseBody = await response.transform(utf8.decoder).join();
  print(responseBody.toString());
}
