import 'dart:io';

import 'package:args/args.dart';

import '../configs.dart';
import '../net/pgyer.dart';
import '../robot/robot.dart';
import '../utils/apk_file.dart';
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
      help: 'Post DingDing message.',
    );
    argParser.addFlag(
      'feishu',
      negatable: false,
      help: 'Post Feishu message.',
    );
  }

  String get file => getString('file');
  String get msg => getString('msg');
  bool get dingding => getBool('dingding');
  bool get feishu => getBool('feishu');

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

    final package = json['data']['appIdentifier'].stringValue;
    final qrcode = json['data']['appQRCodeURL'].stringValue;
    final shortUrl = json['data']['appShortcutUrl'].stringValue;
    final apkUrl = 'https://www.pgyer.com/$shortUrl';

    Robot.post(
      name: apk.fileName,
      url: apkUrl,
      msg: msg,
      image: dingding ? qrcode : configs.getImageKey(package),
      dingding: dingding,
      feishu: feishu,
    );
  }
}
