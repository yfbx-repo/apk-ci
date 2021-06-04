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
  String get userKey => _json['pgyer']['userKey'].stringValue;
  String get apiKey => _json['pgyer']['apiKey'].stringValue;
  //七牛云
  String get accessKey => _json['qiniu']['accessKey'].stringValue;
  String get secretKey => _json['qiniu']['secretKey'].stringValue;
  //钉钉
  String get token => _json['dingding']['token'].stringValue;
  //飞书
  String get appId => _json['feishu']['app_id'].stringValue;
  String get appSecret => _json['feishu']['app_secret'].stringValue;
  String get server => _json['feishu']['server'].stringValue;
  List<JSON> get imageKeys => _json['feishu']['imageKeys'].listValue;

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
