import 'package:args/args.dart';

import '../robot/feishu.dart';
import 'cmd_base.dart';

///
///上传图片到飞书
///
class PostFeishuImage extends BaseCmd {
  @override
  String get description => 'upload image to feishu';

  @override
  String get name => 'upload';

  @override
  void buildArgs(ArgParser argParser) {}

  @override
  void excute() async {
    final args = argResults.arguments;
    if (args == null || args.isEmpty) {
      print('image file is required!');
      return;
    }
    final file = args[0];
    Feishu().uploadImage(file);
  }
}
