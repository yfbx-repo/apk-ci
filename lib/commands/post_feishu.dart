import 'package:args/args.dart';
import 'package:path/path.dart' as path;

import '../configs.dart';
import '../utils/net.dart';
import 'cmd_base.dart';

///
///发送机器人消息
///
class PostFeishu extends BaseCmd {
  @override
  String get description => 'post robot message to feishu';

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
    postFeishu(apkName, url, image, msg);
  }
}

///
/// 发送飞书机器人消息
///
void postFeishu(
  String apkName,
  String apkUrl,
  String imageKey,
  String msg,
) async {
  print('发送飞书机器人消息...');

  //1.换行符分割;2.不能被识别为换行符的\n分割;
  final updateParams = msg
      .split(RegExp(r'\r\n?|\n|\\n'))
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
                  'tag': 'img',
                  'image_key': imageKey,
                  'width': 300,
                  'height': 300
                }
              ],
              [
                {
                  'tag': 'a',
                  'text': apkName,
                  'href': apkUrl,
                }
              ],
              updateParams,
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
