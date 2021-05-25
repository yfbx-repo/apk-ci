import 'package:apk/utils/dingding.dart';
import 'package:apk/utils/feishu.dart';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;

import 'cmd_base.dart';

///
///发送机器人消息
///
class PostCmd extends BaseCmd {
  @override
  String get description => 'post robot message to dingding or feishu';

  @override
  String get name => 'post';

  @override
  void buildArgs(ArgParser argParser) {
    argParser.addOption(
      'file',
      abbr: 'f',
      help: 'The APK file to publish.',
    );
    argParser.addOption(
      'url',
      abbr: 'u',
      help: 'APK download url.',
    );
    argParser.addOption(
      'msg',
      abbr: 'm',
      help: 'The publish message.',
    );
    argParser.addOption(
      'image',
      abbr: 'i',
      help: 'Qrcode image url or image key',
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

    final file = getString('file');

    if (!file.endsWith('.apk')) {
      printUsage();
      return;
    }

    final url = getString('url');
    final msg = getString('msg');
    final image = getString('image');

    if (url.isEmpty) {
      print('apk download url is required!');
      return;
    }

    final needPostDingding = getBool('dingding');
    final needPostFeishu = getBool('feishu');

    final apkName = path.basename(file);
    //发送钉钉消息
    if (needPostDingding) {
      postDingDing(apkName, url, msg, image);
    }
    //发送飞书消息
    if (needPostFeishu) {
      postFeishu(apkName, url, msg, image);
    }
  }
}
