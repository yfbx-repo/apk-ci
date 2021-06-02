import 'package:args/command_runner.dart';
import 'package:ci_tools/commands/apk_runner.dart';
import 'package:ci_tools/commands/post_feishu.dart';
import 'package:ci_tools/commands/post_image.dart';

///
///打包APk->上传APK到蒲公英->发送机器人消息到飞书
///
void main(List<String> arguments) {
  final runner = CommandRunner('fly', '');
  runner.addCommand(PostFeishu());
  runner.addCommand(PostImage());

  if (arguments.isEmpty) {
    runner.printUsage();
    return;
  }

  if (runner.commands.keys.contains(arguments.first)) {
    runner.run(arguments);
  } else {
    ApkRunner.feishu(runner.argParser, arguments).run();
  }
}
