import 'package:apk/utils/net.dart';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;

import '../configs.dart';
import 'cmd_base.dart';

///
///发送机器人消息
///
class PostDing extends BaseCmd {
  @override
  String get description => 'post robot message to dingding';

  @override
  String get name => 'post';

  @override
  void buildArgs(ArgParser argParser) {
    argParser.addOption(
      'file',
      abbr: 'f',
      help: 'The APK file to publish.',
    );
    argParser.addOption(
      'url',
      abbr: 'u',
      help: 'APK download url.',
    );
    argParser.addOption(
      'msg',
      abbr: 'm',
      help: 'The publish message.',
    );
    argParser.addOption(
      'image',
      abbr: 'i',
      help: 'Qrcode image url or image key',
    );
  }

  @override
  void excute() async {
    final args = argResults.arguments;
    if (args == null || args.isEmpty) {
      printUsage();
      return;
    }

    final file = getString('file');

    if (!file.endsWith('.apk')) {
      printUsage();
      return;
    }

    final url = getString('url');
    final msg = getString('msg');
    final image = getString('image');

    if (url.isEmpty) {
      print('apk download url is required!');
      return;
    }

    final apkName = path.basename(file);
    postDingDing(apkName, url, msg, image);
  }
}

///
/// 发送钉钉机器人消息
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
