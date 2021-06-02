import 'dart:io';

import 'package:apk/net/ding.dart';
import 'package:apk/net/feishu.dart';
import 'package:apk/utils/apk_file.dart';
import 'package:args/args.dart';

import '../configs.dart';
import '../net/pgyer.dart';
import 'cmd_base.dart';

///
///上传APK到蒲公英
///
class UploadPgyer extends BaseCmd {
  @override
  String get description => 'upload apk to pgyer and post robot message';

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

  String get file => getString('file');
  String get msg => getString('msg');
  bool get postDingding => getBool('dingding');
  bool get postFeishu => getBool('feishu');

  @override
  void excute() async {
    final args = argResults.arguments;
    if (args == null || args.isEmpty) {
      printUsage();
      return;
    }

    final apkFile = args.length == 1 ? args[0] : file;

    if (!apkFile.endsWith('.apk')) {
      printUsage();
      return;
    }

    final apk = File(apkFile);

    final json = await pgyer.upload(apk, msg);
    if (json['code'].integer != 0) {
      print(json['message'].stringValue);
      return;
    }
    print('上传成功');

    final apkName = apk.fileName;
    final qrcode = json['data']['appQRCodeURL'].stringValue;
    final shortUrl = json['data']['appShortcutUrl'].stringValue;
    final packageName = json['data']['appIdentifier'].stringValue;
    final apkUrl = 'https://www.pgyer.com/$shortUrl';

    //发送钉钉消息
    if (postDingding) {
      ding.post('', apkName, apkUrl, msg, qrcode);
    }
    //发送飞书消息
    if (postFeishu) {
      final imageKey = configs.getImageKey(packageName);
      feishu.post('', apkName, apkUrl, imageKey, msg);
    }
  }
}
