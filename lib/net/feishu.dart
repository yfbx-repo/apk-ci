import 'package:apk/net/net.dart';

import '../configs.dart';

final feishu = _initFeishu();

Feishu _initFeishu() {
  return Feishu._();
}

class Feishu {
  Feishu._();

  ///
  /// 发送飞书机器人消息
  ///
  void post(
    String branch,
    String name,
    String url,
    String image,
    String updateDesc,
  ) async {
    print('发送飞书机器人消息...');
    final result = await net.post(
      configs.feishu,
      feishuJson(
        branch,
        name,
        url,
        image,
        updateDesc.split(RegExp(r'\r\n?|\n|\\n')),
      ),
    );
    if (result['StatusCode'].integer == 0) {
      print('发送成功');
    } else {
      print(result['msg'].stringValue);
    }
  }

  ///
  /// 飞书参数
  ///
  Map<String, dynamic> feishuJson(
    String branch,
    String name,
    String url,
    String image,
    List<String> msg,
  ) {
    return {
      'msg_type': 'post',
      'content': {
        'post': {
          'zh_cn': {
            'title': 'Android APK',
            'content': [
              [
                {'tag': 'img', 'image_key': image, 'width': 300, 'height': 300}
              ],
              [
                {'tag': 'a', 'text': name, 'href': url}
              ],
              [
                {'tag': 'text', 'text': 'branch: $branch'},
                ...msg.map((e) => {'tag': 'text', 'text': e}).toList(),
              ],
            ]
          }
        }
      },
    };
  }
}
