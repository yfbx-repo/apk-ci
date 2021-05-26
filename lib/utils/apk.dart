import 'dart:io';

import 'tools.dart';

extension APK on FileSystemEntity {
  ///
  /// 获取APP中文名
  /// application-label-zh-CN:'寓小二'
  ///
  String get appName => getApkInfo('application-label-zh-CN').split(':').last;

  ///
  /// 获取APK包名
  ///
  String get packageName => packageInfo['name'];

  ///
  /// package: name='com.xxx' versionCode='8599' versionName='8.1.3' compileSdkVersion='29' compileSdkVersionCodename='10'
  ///
  Map get packageInfo {
    final info = getApkInfo('package');
    final firstLine =
        info.split(RegExp(r'\r\n?|\n')).first.replaceFirst('package:', '');
    final array = firstLine.split(' ');
    final map = {};
    for (var it in array) {
      final pair = it.split('=');
      final key = pair.first.trim();
      final value = pair.last.replaceAll('\'', '').trim();
      map[key] = value;
    }
    return map;
  }

  ///
  /// 获取APK信息
  /// 需要配置aapt环境变量，位于AndroidSDK\build-tools目录下
  ///
  String getApkInfo(String filterKey) {
    final filter =
        Platform.isWindows ? '|findStr $filterKey' : '|grep $filterKey';
    final result = runSync('aapt dump badging $path $filter', './');
    return result.stdout.toString().trim();
  }

  String get certMD5 => _getCertInfo('MD5');
  String get certSHA1 => _getCertInfo('SHA1');
  String get certSHA256 => _getCertInfo('SHA256');

  ///
  /// 获取APK签名信息
  /// MD5、SHA1、SHA256
  ///
  String _getCertInfo(String type) {
    final filter = Platform.isWindows ? '|findStr /i $type' : '|grep -i $type';
    final cmd = 'keytool -list -printcert -jarfile $path $filter';
    final result = runSync(cmd, './');
    final info = result.stdout.toString().trim();
    return info.replaceFirst('$type:', '').trim();
  }
}
