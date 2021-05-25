import 'package:apk/commands/apk_runner.dart';
import 'package:apk/commands/cmd_cert.dart';
import 'package:apk/commands/cmd_feishu.dart';
import 'package:apk/commands/cmd_post.dart';
import 'package:apk/commands/cmd_publish.dart';
import 'package:args/command_runner.dart';

void main(List<String> arguments) {
  final runner = CommandRunner('apk', 'apk tools');
  final apkRunner = ApkRunner(runner.argParser);

  runner.addCommand(CertCmd());
  runner.addCommand(PublishCmd());
  runner.addCommand(PostCmd());
  runner.addCommand(FeishuCmd());

  if (arguments.isEmpty) {
    apkRunner.run(arguments);
    return;
  }

  if (arguments.first == '--help' || arguments.first == '-h') {
    runner.run(arguments);
    return;
  }

  if (runner.commands.keys.contains(arguments.first)) {
    runner.run(arguments);
    return;
  }

  apkRunner.run(arguments);
}
