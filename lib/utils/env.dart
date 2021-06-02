import 'package:path/path.dart' as path;

final env = _initEnv();

Env _initEnv() => Env._();

class Env {
  Env._();

  ///
  ///当前工作路径
  ///
  String get currentPath => '${path.current}${path.separator}';
}
