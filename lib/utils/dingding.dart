import '../configs.dart';
import 'net.dart';

///
/// 发送飞书机器人消息
///
void postDingDing(
  String apkName,
  String apkUrl,
  String updateDesc,
  String imageKey,
) async {
  print('发送钉钉机器人消息...');

  final markdown = '''
  ![](${imageKey})    
  下载链接：[$apkName]($apkUrl)    
  更新内容：$updateDesc    
  ''';

  final result = await post(
    'https://oapi.dingtalk.com/robot/send?access_token=${configs.token}',
    {
      'msgtype': 'markdown',
      'markdown': {
        'title': 'Android APK',
        'text': markdown,
      },
    },
  );

  if (result['errcode'].integer == 0) {
    print('发送成功');
  } else {
    print(result['errmsg'].stringValue);
  }
}
