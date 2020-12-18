import 'dart:io';

import 'package:apk/tools/common.dart';
import 'package:apk/tools/pgyer_uploader.dart';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:shell/shell.dart';

class ApkRunner {
  final ArgParser argParser;
  final shell = Shell();

  ApkRunner(this.argParser) {
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
    //钉钉机器人消息
    argParser.addOption(
      'msg',
      abbr: 'm',
      help: 'The DingTalk robot message',
    );
  }

  void run(List<String> arguments) {
    final args = argParser.parse(arguments);
    if (args.getBool('help')) {
      print(argParser.usage);
      return;
    }

    ///参数
    final isRelease = args.getBool('release');
    final flavor = args.getString('flavor');
    final msg = args.getString('msg');
    final project = args.getString('path', defaultValue: './');
    shell.workingDirectory = project;

    //原生项目打包
    if (isNativeProject(project)) {
      buildNativeApk(project, isRelease, flavor).then(
        (apk) => publish(apk, msg),
      );
      return;
    }

    //Flutter项目打包
    if (isFlutterProject(project)) {
      buildFlutterApk(project, isRelease, flavor).then(
        (apk) => publish(apk, msg),
      );
      return;
    }

    stderr.write('\nERROR:请在项目根目录下执行命令，或使用 -p 参数指定项目路径\n');
  }

  ///
  ///原生打包
  ///
  Future<FileSystemEntity> buildNativeApk(
    String project,
    bool isRelease,
    String flavor,
  ) async {
    final type = isRelease ? 'Release' : 'Debug';
    await shell.startAndReadAsString('gradlew', ['clean']);
    await shell.startAndReadAsString('gradlew', ['assemble$flavor$type']);

    final files = await Directory(project).list(
      recursive: true, //递归到子目录
      followLinks: false, //不包含链接
    );
    return files.firstWhere((file) => path.extension(file.path) == '.apk');
  }

  ///
  ///Flutter项目打包
  ///
  Future<FileSystemEntity> buildFlutterApk(
    String project,
    bool isRelease,
    String flavor,
  ) async {
    final type = isRelease ? '--release' : '--debug';
    await shell.startAndReadAsString('flutter', ['clean']);
    await shell.startAndReadAsString(
      'flutter',
      ['build', 'apk', type, if (flavor.isNotEmpty) '--flavor $flavor'],
    );

    final dir = '$project/build';
    final files = await Directory(dir).list(
      recursive: true, //递归到子目录
      followLinks: false, //不包含链接
    );
    return files.firstWhere((file) => path.extension(file.path) == '.apk');
  }

  bool isNativeProject(String project) {
    return File('$project\\gradlew.bat').existsSync();
  }

  bool isFlutterProject(String project) {
    return File('$project\\pubspec.yaml').existsSync();
  }
}
