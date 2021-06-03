import 'package:apk_ci/commands/apk_runner.dart';
import 'package:apk_ci/commands/post_msg.dart';
import 'package:apk_ci/commands/print_info.dart';
import 'package:apk_ci/commands/upload_pgyer.dart';
import 'package:args/command_runner.dart';

///
///打包APk->上传APK到蒲公英->发送机器人消息
///
void main(List<String> arguments) {
  final runner = CommandRunner('apk', 'apk tools');
  runner.addCommand(PrintInfo());
  runner.addCommand(UploadPgyer());
  runner.addCommand(PostMsg());

  if (arguments.isEmpty) {
    runner.printUsage();
    return;
  }

  if (runner.commands.keys.contains(arguments.first)) {
    runner.run(arguments);
  } else {
    ApkRunner(runner.argParser, arguments).run();
  }
}
