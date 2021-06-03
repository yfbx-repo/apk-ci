import 'package:args/args.dart';
import 'package:path/path.dart' as path;

import '../robot/robot.dart';
import 'cmd_base.dart';

///
///发送机器人消息
///
class PostMsg extends BaseCmd {
  @override
  String get description => 'post robot message';

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
      help: 'Post dingding robot message.',
    );
    argParser.addFlag(
      'feishu',
      negatable: false,
      help: 'Post feishu robot message.',
    );
  }

  String get file => getString('file');
  String get url => getString('url');
  String get msg => getString('msg');
  String get image => getString('image');
  bool get dingding => getBool('dingding');
  bool get feishu => getBool('feishu');

  @override
  void excute() async {
    final args = argResults.arguments;
    if (args == null || args.isEmpty) {
      printUsage();
      return;
    }

    if (!file.endsWith('.apk')) {
      printUsage();
      return;
    }

    if (url.isEmpty) {
      print('apk download url is required!');
      return;
    }

    Robot.post(
      name: path.basename(file),
      url: url,
      msg: msg,
      image: image,
      dingding: dingding,
      feishu: feishu,
    );
  }
}
