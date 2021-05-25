import 'package:apk/configs.dart';

import 'net.dart';

///
/// 发送飞书机器人消息
///
void postFeishu(
  String apkName,
  String apkUrl,
  String updateDesc,
  String imageKey,
) async {
  print('发送飞书机器人消息...');

  final updateParams = updateDesc
      .split(RegExp(r'\r\n?|\n'))
      .map((e) => {'tag': 'text', 'text': e})
      .toList();

  final result = await post(
    configs.feishu,
    {
      'msg_type': 'post',
      'content': {
        'post': {
          'zh_cn': {
            'title': 'Android APK',
            'content': [
              [
                {
                  'tag': 'a',
                  'text': apkName,
                  'href': apkUrl,
                }
              ],
              updateParams,
              [
                {
                  'tag': 'img',
                  'image_key': imageKey,
                  'width': 300,
                  'height': 300
                }
              ]
            ]
          }
        }
      },
    },
  );

  if (result['StatusCode'].integer == 0) {
    print('发送成功');
  } else {
    print(result['msg'].stringValue);
  }
}
