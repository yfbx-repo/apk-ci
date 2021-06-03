import '../configs.dart';
import 'ding.dart';
import 'feishu.dart';

class Robot {
  Robot.post({
    String branch = '',
    String name = '',
    String url = '',
    String msg = '',
    String image = '',
    bool dingding = false,
    bool feishu = false,
  }) {
    if (dingding) {
      DingDing().post(branch, name, url, msg, image);
    }
    if (feishu) {
      Feishu().post(branch, name, url, msg, image);
    }

    //如果没有该参数，读取配置，根据配置post
    if (!dingding && !feishu) {
      if (configs.token.isNotEmpty) {
        DingDing().post(branch, name, url, msg, image);
      }
      if (configs.server.isNotEmpty) {
        Feishu().post(branch, name, url, msg, image);
      }
    }
  }
}
