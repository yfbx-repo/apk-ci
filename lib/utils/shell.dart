import 'dart:async';
import 'dart:io';

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
