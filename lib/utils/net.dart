import 'dart:io';

import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';
import 'package:path/path.dart' as path;

import '../configs.dart';

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

///
/// 发送机器人消息
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

///
/// 上传图片到飞书
///
void uploadImage(String path) async {
  //获取token
  final token = await Dio().post(
    'https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal/',
    data: {
      'app_id': 'cli_a02671a31838100d',
      'app_secret': '3G1zk4z95OmNKcNr9G98PbWU2NLmIR8b',
    },
  );
  print(token);
  //{"code":0,"expire":7200,"msg":"ok","tenant_access_token":"t-a98bbd932b3847ca098beaac6895ab4856191d48"}
  final json = JSON.parse(token.toString());
  final tenantAccessToken = json['tenant_access_token'].stringValue;

  //上传图片
  final result = await Dio().post(
    'https://open.feishu.cn/open-apis/image/v4/put/',
    data: FormData.fromMap({
      'image_type': 'message',
      'image': MultipartFile.fromFileSync(path),
    }),
    options: Options(headers: {
      'Authorization': 'Bearer $tenantAccessToken',
    }),
  );
  print(result);
}
