import 'dart:io';

import 'package:apk/utils/ding.dart';
import 'package:apk/utils/feishu.dart';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;

import '../configs.dart';
import '../utils/net.dart';
import 'cmd_base.dart';

///
///上传APK到蒲公英
///
class UploadPgyer extends BaseCmd {
  @override
  String get description =>
      'upload apk to pgyer and post to dingding or feishu';

  @override
  String get name => 'publish';

  @override
  void buildArgs(ArgParser argParser) {
    argParser.addOption(
      'file',
      abbr: 'f',
      help: 'The APK file to publish.',
    );
    argParser.addOption(
      'msg',
      abbr: 'm',
      help: 'The publish message.',
    );
    argParser.addFlag(
      'dingding',
      negatable: false,
      help: 'If need to post DingDing message.',
    );
    argParser.addFlag(
      'feishu',
      negatable: false,
      help: 'If need to post Feishu message.',
    );
  }

  @override
  void excute() async {
    final args = argResults.arguments;
    if (args == null || args.isEmpty) {
      printUsage();
      return;
    }

    final file = args.length == 1 ? args[0] : getString('file');

    if (!file.endsWith('.apk')) {
      printUsage();
      return;
    }

    final needPostDingding = getBool('dingding');
    final needPostFeishu = getBool('feishu');
    final msg = getString('msg');

    final apk = File(file);

    final json = await net.upload(apk, msg);
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

    //发送钉钉消息
    if (needPostDingding) {
      ding.post('', apkName, apkUrl, msg, qrcode);
    }
    //发送飞书消息
    if (needPostFeishu) {
      final imageKey = configs.getImageKey(packageName);
      feishu.post(apkName, apkUrl, imageKey, msg);
    }
  }
}
