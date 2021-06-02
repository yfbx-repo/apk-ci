import 'dart:io';

import 'package:args/args.dart';

import '../utils/apk_file.dart';
import 'cmd_base.dart';

///
///打印APK信息
///
class PrintInfo extends BaseCmd {
  @override
  String get description => 'print apk package information';

  @override
  String get name => 'print';

  @override
  void buildArgs(ArgParser argParser) {
    argParser.addOption(
      'file',
      abbr: 'f',
      help: 'The APK file.',
    );

    argParser.addFlag('package', negatable: false, abbr: 'p');
    argParser.addFlag('MD5', negatable: false);
    argParser.addFlag('SHA1', negatable: false);
    argParser.addFlag('SHA256', negatable: false);
  }

  String get file => getString('file');
  bool get printPackage => getBool('package');
  bool get printMD5 => getBool('MD5');
  bool get printSHA1 => getBool('SHA1');
  bool get printSHA256 => getBool('SHA256');

  @override
  void excute() async {
    final args = argResults.arguments;
    if (args == null || args.isEmpty) {
      printUsage();
      return;
    }
    final filePath = file.isEmpty ? args.last : file;
    if (!filePath.endsWith('.apk')) {
      printUsage();
      return;
    }

    final apk = File(filePath);

    if (printMD5) {
      print(apk.certMD5);
      print(apk.certMD5.split(':').join());
    }
    if (printSHA1) {
      print(apk.certSHA1);
      print(apk.certSHA1.split(':').join());
    }
    if (printSHA256) {
      print(apk.certSHA256);
      print(apk.certSHA256.split(':').join());
    }
    if (printPackage) {
      print(apk.getApkInfo('package'));
    }
  }
}
