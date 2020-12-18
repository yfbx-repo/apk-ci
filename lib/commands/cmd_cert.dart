import 'package:args/args.dart';
import 'package:shell/shell.dart';

import 'cmd_base.dart';

///
///打印APK签名信息
///
class CertCmd extends BaseCmd {
  final shell = Shell();

  @override
  String get description => 'print apk cert infomation';

  @override
  String get name => 'printcert';

  @override
  void buildArgs(ArgParser argParser) {}

  @override
  void excute() async {
    final args = argResults.arguments;

    if (args == null || args.isEmpty || args.length > 1) {
      printHelpInfo();
      return;
    }
    final file = args[0];
    if (!file.endsWith('.apk')) {
      printHelpInfo();
      return;
    }

    final result = await shell.run(
      'keytool',
      ['-list', '-printcert', '-jarfile', file],
    );
    final info = result.stdout;
    print(info);
    final startIndex = info.indexOf('MD5:') + 6;
    final endIndex = startIndex + 48;
    final cert = info.substring(startIndex, endIndex).replaceAll(':', '');
    print('cert: $cert\n');
  }

  void printHelpInfo() {
    print('\n命令格式：apk printcert [apk file]              打印APK签名信息\n');
  }
}
