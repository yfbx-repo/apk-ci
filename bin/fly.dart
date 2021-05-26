import 'package:apk/commands/post_feishu.dart';
import 'package:apk/commands/post_image.dart';
import 'package:apk/configs.dart';
import 'package:apk/utils/builder.dart';
import 'package:apk/utils/feishu.dart';
import 'package:apk/utils/net.dart';
import 'package:apk/utils/tools.dart';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as path;

void main(List<String> arguments) {
  final runner = CommandRunner('fly', '');
  buildArgs(runner.argParser);

  runner.addCommand(PostFeishu());
  runner.addCommand(PostImage());

  if (arguments.isEmpty) {
    runApk(runner.argParser, arguments);
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

  runApk(runner.argParser, arguments);
}

void buildArgs(ArgParser argParser) {
//release apk
  argParser.addFlag(
    'release',
    abbr: 'r',
    negatable: false,
    help: 'Build a release version of your app.',
  );
  //debug apk 默认
  argParser.addFlag(
    'debug',
    abbr: 'd',
    negatable: false,
    help: 'Build a debug version of your app (default mode).',
  );
  //多渠道，指定渠道
  argParser.addOption(
    'flavor',
    abbr: 'f',
    help: 'Build a custom  flavor app.',
  );
  //项目路径
  argParser.addOption(
    'path',
    abbr: 'p',
    help: 'Your project directory path',
  );
  //飞书机器人消息
  argParser.addOption(
    'msg',
    abbr: 'm',
    help: 'The robot message post to feishu',
  );
}

void runApk(ArgParser argParser, List<String> arguments) async {
  final args = argParser.parse(arguments);
  if (args.getBool('help')) {
    print(argParser.usage);
    return;
  }
  // build apk
  final builder = Builder(args);
  final apk = await builder.buildApk();
  if (apk == null) {
    return;
  }

  // upload
  final json = await net.upload(apk, builder.msg);
  if (json['code'].integer != 0) {
    print(json['message'].stringValue);
    return;
  }
  print('上传成功');

  // params
  final apkName = path.basename(apk.path);
  final package = json['data']['appIdentifier'].stringValue;
  final shortUrl = json['data']['appShortcutUrl'].stringValue;
  final apkUrl = 'https://www.pgyer.com/$shortUrl';

  //branch name
  final result = runSync('git symbolic-ref --short HEAD', builder.project);
  final branchName = result.stdout;
  final updateDesc = 'branch:$branchName \n${builder.msg}';

  // publish
  feishu.post(apkName, apkUrl, configs.getImageKey(package), updateDesc);
}
