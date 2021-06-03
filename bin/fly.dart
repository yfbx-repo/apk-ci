import 'package:apk_ci/commands/post_feishu_image.dart';
import 'package:args/command_runner.dart';

///
///飞书
///
void main(List<String> arguments) {
  final runner = CommandRunner('fly', 'feishu tools');
  runner.addCommand(PostFeishuImage());

  if (arguments.isEmpty) {
    runner.printUsage();
    return;
  }

  if (runner.commands.keys.contains(arguments.first)) {
    runner.run(arguments);
  } else {
    runner.printUsage();
  }
}
