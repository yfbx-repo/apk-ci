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
    'https://open.feishu.cn/open-apis/bot/v2/hook/cd0562bb-0b22-49ec-8ef6-68e55ef6311d',
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
              [
                {'tag': 'text', 'text': '更新内容 :'},
                ...updateParams,
              ],
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
