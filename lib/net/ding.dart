import '../configs.dart';
import '../net/net.dart';

final ding = _initDing();

Ding _initDing() {
  return Ding();
}

class Ding {
  final server = 'https://oapi.dingtalk.com/robot/send?';

  ///
  /// 发送钉钉机器人消息
  ///
  void post(
    String branch,
    String name,
    String url,
    String msg,
    String image,
  ) async {
    print('发送钉钉机器人消息...');

    final buffer = StringBuffer();
    buffer.writeln('![]($image)    ');
    buffer.writeln('branch: $branch    ');
    buffer.writeln('apk: [$name]($url)    ');
    msg.split(RegExp(r'\r\n?|\n|\\n')).forEach((e) {
      buffer.writeln('$e    ');
    });
    final markdown = buffer.toString();

    final result = await net.post(
      '${server}access_token=${configs.token}',
      data: {
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
}
