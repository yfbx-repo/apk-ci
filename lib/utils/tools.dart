import 'dart:async';
import 'dart:io';

import 'package:apk/utils/dingding.dart';
import 'package:apk/utils/feishu.dart';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;

import 'net.dart';

///
///上传到蒲公英并发送钉钉消息
///
void publish(FileSystemEntity apk, String msg) async {
  final json = await upload(apk, msg);
  if (json['code'].integer != 0) {
    print(json['message'].stringValue);
    return;
  }
  print('上传成功');
  final apkName = path.basename(apk.path);
  final qrcode = json['data']['appQRCodeURL'].stringValue;
  final shortUrl = json['data']['appShortcutUrl'].stringValue;
  final packageName = json['data']['appIdentifier'].stringValue;
  final apkUrl = 'https://www.pgyer.com/$shortUrl';
  postDingDing(apkName, apkUrl, msg, qrcode);

  final imageKey = packageName == 'com.yuxiaor'
      ? 'img_v2_2827ce84-1281-4036-8539-2b812cc9525g'
      : '';
  postFeishu(apkName, apkUrl, msg, imageKey);
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

Future<void> shell(String command, String workDir) async {
  final process = await Process.start(
    command,
    [],
    workingDirectory: workDir,
    runInShell: true,
  );

  final completer = Completer();
  process.stdout.listen(
    (event) {
      print(String.fromCharCodes(event));
    },
    onDone: () => completer.complete(),
  );

  return completer.future;
}

ProcessResult runSync(String command, String workDir) {
  return Process.runSync(
    command,
    [],
    workingDirectory: workDir,
    runInShell: true,
  );
}
