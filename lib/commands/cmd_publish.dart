import 'dart:io';

import 'package:apk/tools.dart';
import 'package:args/args.dart';

import 'cmd_base.dart';

///
///上传APK到蒲公英
///
class PublishCmd extends BaseCmd {
  @override
  String get description => 'upload apk to pgyer and post to dingding';

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
      'post',
      abbr: 'p',
      negatable: false,
      help: 'If need to post DingDing message.',
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

    final needPost = getBool('post');
    final msg = getString('msg');

    if (needPost) {
      await publish(File(file), msg);
    } else {
      await upload2Pgy(File(file), msg);
    }
  }
}
