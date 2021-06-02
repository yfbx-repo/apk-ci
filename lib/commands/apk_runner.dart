import 'package:args/args.dart';

import '../configs.dart';
import '../net/ding.dart';
import '../net/feishu.dart';
import '../net/pgyer.dart';
import '../utils/apk_builder.dart';
import '../utils/apk_file.dart';
import '../utils/args.dart';
import '../utils/shell.dart';

class ApkRunner {
  final ArgParser argParser;
  final List<String> arguments;
  final String channel;

  ApkRunner.dingding(this.argParser, this.arguments) : channel = 'dingding' {
    _buildArgs();
  }

  ApkRunner.feishu(this.argParser, this.arguments) : channel = 'feishu' {
    _buildArgs();
  }

  void _buildArgs() {
    //release apk
    argParser.addFlag(
      'release',
      abbr: 'r',
      negatable: false,
      help: 'Build a release version of your app.',
    );
    //debug apk 默认
    argParser.addFlag(
      'debug',
      abbr: 'd',
      negatable: false,
      help: 'Build a debug version of your app (default mode).',
    );
    //多渠道，指定渠道
    argParser.addOption(
      'flavor',
      abbr: 'f',
      help: 'Build a custom  flavor app.',
    );
    //项目路径
    argParser.addOption(
      'path',
      abbr: 'p',
      help: 'Your project directory path',
    );
    //机器人消息
    argParser.addOption(
      'msg',
      abbr: 'm',
      help: 'The robot message post to dingding or feishu',
    );
  }

  void run() async {
    final results = argParser.parse(arguments);
    if (results.getBool('help')) {
      print(argParser.usage);
      return;
    }

    final builder = ApkBuilder(results);
    final apk = await builder.buildApk();
    if (apk == null) {
      return;
    }

    //upload
    final json = await pgyer.upload(apk, builder.msg);
    if (json['code'].integer != 0) {
      print(json['message'].stringValue);
      return;
    }
    print('上传成功');

    //params
    final apkName = apk.fileName;
    final package = json['data']['appIdentifier'].stringValue;
    final qrcode = json['data']['appQRCodeURL'].stringValue;
    final shortUrl = json['data']['appShortcutUrl'].stringValue;
    final apkUrl = 'https://www.pgyer.com/$shortUrl';
    //branch name
    final result = runSync('git symbolic-ref --short HEAD', builder.project);
    final branchName = result.stdout;
    //publish
    if (channel == 'dingding') {
      ding.post(branchName, apkName, apkUrl, builder.msg, qrcode);
    }
    if (channel == 'feishu') {
      feishu.post(
        branchName,
        apkName,
        apkUrl,
        configs.getImageKey(package),
        builder.msg,
      );
    }
  }
}
