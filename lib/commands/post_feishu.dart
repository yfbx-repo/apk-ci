import 'package:apk/utils/feishu.dart';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;

import 'cmd_base.dart';

///
///发送机器人消息
///
class PostFeishu extends BaseCmd {
  @override
  String get description => 'post robot message to feishu';

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

    final apkName = path.basename(file);
    feishu.post('', apkName, url, image, msg);
  }
}
