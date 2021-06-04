import 'dart:convert';

import 'package:apk_ci/configs.dart';
import 'package:apk_ci/net/net.dart';
import 'package:apk_ci/utils/args.dart';
import 'package:args/args.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';
import 'package:path/path.dart' as _path;

///
/// 上传文件到七牛云
///
void main(List<String> args) {
  if (args == null || args.isEmpty) {
    print('Usage: qiniu -p <prefix> <file path>');
    return;
  }

  final argParser = ArgParser();
  argParser.addOption('prefix', abbr: 'p');
  final argResult = argParser.parse(args);
  final prefix = argResult.getString('prefix');
  final filePath = args.last;
  upload(filePath, prefix);
}

///
/// 上传
///
void upload(String filePath, String prefix) {
  final fileName = _path.basename(filePath);
  final token = genToken();
  final key = '$prefix/$fileName';
  net.post(
    'https://up.qbox.me/',
    data: FormData.fromMap({
      'token': token,
      'key': key,
      'save_key': 'false',
      'unique_names': 'false',
      'file': MultipartFile.fromFileSync(filePath, filename: fileName),
    }),
  );
}

String genToken() {
  final accessKey = configs.accessKey;
  final secretKey = configs.secretKey;
  final now = DateTime.now().millisecondsSinceEpoch;
  final deadline = Duration(milliseconds: now) + Duration(seconds: 3600);

  //上传策略 json 字符串
  final policy = JSON({
    'scope': 'apartment',
    'deadline': deadline.inSeconds,
  }).rawString();

  //base 64
  final policy64 = base64Url.encode(utf8.encode(policy));

  //签名
  final hmac =
      Hmac(sha1, utf8.encode(secretKey)).convert(utf8.encode(policy64)).bytes;

  final encodeSign = base64Url.encode(hmac);

  return '$accessKey:$encodeSign:$policy64';
}
