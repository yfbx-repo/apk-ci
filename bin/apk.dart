import 'package:apk/commands/apk_runner.dart';
import 'package:apk/commands/post_dingding.dart';
import 'package:apk/commands/print_info.dart';
import 'package:apk/commands/upload_pgyer.dart';
import 'package:args/command_runner.dart';

///
///打包APk->上传APK到蒲公英->发送机器人消息到钉钉
///
void main(List<String> arguments) {
  final runner = CommandRunner('apk', 'apk tools');
  runner.addCommand(PrintInfo());
  runner.addCommand(UploadPgyer());
  runner.addCommand(PostDing());

  if (arguments.isEmpty) {
    runner.printUsage();
    return;
  }

  if (runner.commands.keys.contains(arguments.first)) {
    runner.run(arguments);
  } else {
    ApkRunner.dingding(runner.argParser, arguments).run();
  }
}
