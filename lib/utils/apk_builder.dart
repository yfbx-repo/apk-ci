import 'dart:io';

import 'package:apk/utils/env.dart';
import 'package:args/args.dart';

import 'args.dart';
import 'shell.dart';

class ApkBuilder {
  final ArgResults args;

  ApkBuilder(this.args);

  bool get isRelease => args.getBool('release');
  String get flavor => args.getString('flavor');
  String get msg => args.getString('msg');
  String get project => args.getString('path', defaultValue: './');

  bool get isNative {
    return File('$project\\gradlew.bat').existsSync();
  }

  bool get isFlutter {
    return File('$project\\pubspec.yaml').existsSync();
  }

  ///
  /// build apk
  ///
  Future<FileSystemEntity> buildApk() {
    if (isNative) {
      return buildNative();
    }

    if (isFlutter) {
      return buildFlutter();
    }

    stderr.write('\nERROR:请在项目根目录下执行命令，或使用 -p 参数指定项目路径\n');
    return null;
  }

  ///
  ///原生打包
  ///
  Future<FileSystemEntity> buildNative() async {
    final type = isRelease ? 'Release' : 'Debug';

    print('\n正在清理文件...\n');
    await shell('gradlew clean', project);

    print('\n正在打包...\n');
    await shell('gradlew assemble$flavor$type', project);

    return env.findApk(project);
  }

  ///
  ///Flutter项目打包
  ///
  Future<FileSystemEntity> buildFlutter() async {
    final type = isRelease ? '--release' : '--debug';
    final flavorType = flavor.isEmpty ? '' : '--flavor $flavor';

    print('\n正在清理文件...\n');
    await shell('flutter clean', project);

    print('\n正在打包...\n');
    await shell('flutter build apk $type $flavorType', project);

    return env.findApk('$project/build');
  }
}
