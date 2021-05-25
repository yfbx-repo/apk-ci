import 'dart:io';

import 'package:g_json/g_json.dart';

///
/// 配置信息
///
class Configs {
  JSON _json;

  Configs._() {
    final filePath = 'D:\\demos\\apk_ci\\configs.json';
    final jsonStr = File(filePath).readAsStringSync();
    _json = JSON.parse(jsonStr);
  }

  String get userKey => _json['userKey'].stringValue;
  String get apiKey => _json['apiKey'].stringValue;
  String get token => _json['token'].stringValue;
  String get feishu => _json['feishu'].stringValue;
  List<JSON> get imageKeys => _json['imageKeys'].listValue;
  String getImageKey(String package) {
    final item = imageKeys.firstWhere(
      (e) => e['package'].stringValue == package,
      orElse: () => JSON.nil,
    );
    return item['key'].stringValue;
  }
}

final configs = _initConfigs();

Configs _initConfigs() => Configs._();
