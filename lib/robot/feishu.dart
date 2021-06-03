import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';

import '../configs.dart';
import '../net/net.dart';

class Feishu {
  ///
  /// 发送飞书机器人消息
  ///
  void post(
    String branch,
    String name,
    String url,
    String msg,
    String image,
  ) async {
    print('发送飞书机器人消息...');
    final result = await net.post(
      configs.server,
      data: _buildArgs(
        branch,
        name,
        url,
        image,
        msg.split(RegExp(r'\r\n?|\n|\\n')),
      ),
    );
    if (result['StatusCode'].integer == 0) {
      print('发送成功');
    } else {
      print(result['msg'].stringValue);
    }
  }

  ///
  /// 飞书参数
  ///
  Map<String, dynamic> _buildArgs(
    String branch,
    String name,
    String url,
    String image,
    List<String> msg,
  ) {
    return {
      'msg_type': 'post',
      'content': {
        'post': {
          'zh_cn': {
            'title': 'Android APK',
            'content': [
              [
                {'tag': 'img', 'image_key': image, 'width': 300, 'height': 300}
              ],
              [
                {'tag': 'a', 'text': name, 'href': url}
              ],
              [
                {'tag': 'text', 'text': 'branch: $branch'},
                ...msg.map((e) => {'tag': 'text', 'text': e}).toList(),
              ],
            ]
          }
        }
      },
    };
  }

  ///
  /// 上传图片到飞书
  ///
  void uploadImage(String path) async {
    //获取token
    final token = await net.post(
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
    final result = await net.post(
      'https://open.feishu.cn/open-apis/image/v4/put/',
      data: FormData.fromMap({
        'image_type': 'message',
        'image': MultipartFile.fromFileSync(path),
      }),
      headers: {
        'Authorization': 'Bearer $tenantAccessToken',
      },
    );
    print(result);
  }
}
