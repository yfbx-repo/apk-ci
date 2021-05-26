import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';

///
///取参扩展
///
extension Args on ArgResults {
  String getString(String key, {String defaultValue = ''}) {
    final value = this[key];
    return value ?? defaultValue;
  }

  bool getBool(String key, {bool defaultValue = false}) {
    final value = this[key];
    return value ?? defaultValue;
  }
}

Future<void> shell(String command, String workDir) async {
  final process = await Process.start(
    command,
    [],
    workingDirectory: workDir,
    runInShell: true,
  );

  final completer = Completer();
  process.stdout.listen(
    (event) {
      print(String.fromCharCodes(event));
    },
    onDone: () => completer.complete(),
  );

  return completer.future;
}

ProcessResult runSync(String command, String workDir) {
  return Process.runSync(
    command,
    [],
    workingDirectory: workDir,
    runInShell: true,
  );
}
