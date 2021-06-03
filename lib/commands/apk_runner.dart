import 'package:args/args.dart';

import '../configs.dart';
import '../net/pgyer.dart';
import '../robot/robot.dart';
import '../utils/apk_builder.dart';
import '../utils/apk_file.dart';
import '../utils/args.dart';
import '../utils/shell.dart';

class ApkRunner {
  final ArgParser argParser;
  final List<String> arguments;

  ApkRunner(this.argParser, this.arguments) {
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
    argParser.addFlag(
      'dingding',
      negatable: false,
      help: 'Post dingding robot message.',
    );
    argParser.addFlag(
      'feishu',
      negatable: false,
      help: 'Post feishu robot message.',
    );
  }

  void run() async {
    final results = argParser.parse(arguments);
    if (results.getBool('help')) {
      print(argParser.usage);
      return;
    }

    final dingding = results.getBool('dingding');
    final feishu = results.getBool('feishu');

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
    final package = json['data']['appIdentifier'].stringValue;
    final qrcode = json['data']['appQRCodeURL'].stringValue;
    final shortUrl = json['data']['appShortcutUrl'].stringValue;
    final apkUrl = 'https://www.pgyer.com/$shortUrl';
    //branch name
    final result = runSync('git symbolic-ref --short HEAD', builder.project);
    final branchName = result.stdout;
    //publish
    Robot.post(
      branch: branchName,
      name: apk.fileName,
      url: apkUrl,
      msg: builder.msg,
      image: dingding ? qrcode : configs.getImageKey(package),
      dingding: dingding,
      feishu: feishu,
    );
  }
}
