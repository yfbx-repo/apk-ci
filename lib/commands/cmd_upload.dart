import 'dart:io';

import 'package:args/args.dart';
import 'package:apk/tools/pgyer_uploader.dart';

import 'cmd_base.dart';

///
///上传APK到蒲公英
///
class UploadCmd extends BaseCmd {
  @override
  String get description => 'upload apk to pgyer';

  @override
  String get name => 'upload';

  @override
  void buildArgs(ArgParser argParser) {}

  @override
  void excute() async {
    final args = argResults.arguments;

    if (args == null || args.isEmpty || args.length > 1) {
      printHelpInfo();
      return;
    }
    final file = args[0];
    if (!file.endsWith('.apk')) {
      printHelpInfo();
      return;
    }

    await upload2Pgy(File(file), '');
  }

  void printHelpInfo() {
    print('\n命令格式：apk upload [apk file]              上传APK到蒲公英\n');
  }
}
