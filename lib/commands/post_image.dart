import 'package:apk/configs.dart';
import 'package:args/args.dart';
import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';

import 'cmd_base.dart';

///
///上传图片到飞书
///
class PostImage extends BaseCmd {
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
    uploadImage(file);
  }
}

///
/// 上传图片到飞书
///
void uploadImage(String path) async {
  //获取token
  final token = await Dio().post(
    'https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal/',
    data: {
      'app_id': configs.appId,
      'app_secret': configs.appSecret,
    },
  );
  print(token);
  final json = JSON.parse(token.toString());
  final tenantAccessToken = json['tenant_access_token'].stringValue;

  //上传图片
  final result = await Dio().post(
    'https://open.feishu.cn/open-apis/image/v4/put/',
    data: FormData.fromMap({
      'image_type': 'message',
      'image': MultipartFile.fromFileSync(path),
    }),
    options: Options(headers: {
      'Authorization': 'Bearer $tenantAccessToken',
    }),
  );
  print(result);
}
