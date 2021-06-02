import 'package:g_json/g_json.dart';

import '../utils/env.dart';

///
/// 配置信息
///
class Configs {
  JSON _json;

  Configs._() {
    //TODO:本地配置文件路径
    final jsonStr = env.readFile('D:\\demos\\apk_ci\\configs.json');
    _json = JSON.parse(jsonStr);
  }

  //蒲公英
  String get userKey => _json['userKey'].stringValue;
  String get apiKey => _json['apiKey'].stringValue;
  //钉钉
  String get token => _json['token'].stringValue;
  //飞书
  String get feishu => _json['feishu'].stringValue;
  String get appId => _json['app_id'].stringValue;
  String get appSecret => _json['app_secret'].stringValue;
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
