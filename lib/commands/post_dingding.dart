import 'package:args/args.dart';
import 'package:path/path.dart' as path;

import '../net/ding.dart';
import 'cmd_base.dart';

///
///发送机器人消息
///
class PostDing extends BaseCmd {
  @override
  String get description => 'post robot message to dingding';

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
  }

  String get file => getString('file');
  String get url => getString('url');
  String get msg => getString('msg');
  String get image => getString('image');

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

    final apkName = path.basename(file);

    ding.post('', apkName, url, msg, image);
  }
}
