import 'dart:io';

import 'package:path/path.dart' as _path;

final env = _initEnv();

Env _initEnv() => Env._();

class Env {
  Env._();

  ///
  ///当前工作路径
  ///
  String get currentPath => '${_path.current}${_path.separator}';

  ///
  /// 查找APK文件
  ///
  File findApk(String dir) {
    return Directory(dir)
        .listSync(
          recursive: true, //递归到子目录
          followLinks: false, //不包含链接
        )
        .firstWhere(
          (file) => _path.extension(file.path) == '.apk',
          orElse: () => null,
        );
  }

  ///
  ///读取文件内容
  ///
  String readFile(String path) {
    if (path == null || path.isEmpty) return '';
    final txtFile = File(path);
    if (txtFile.existsSync()) {
      return txtFile.readAsStringSync();
    }
    return '';
  }
}
