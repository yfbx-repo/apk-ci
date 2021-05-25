import 'dart:async';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:apk/utils/tools.dart';

abstract class BaseCmd extends Command {
  BaseCmd() {
    buildArgs(argParser);
  }

  @override
  FutureOr<bool> run() {
    excute();
    return true;
  }

  void buildArgs(ArgParser argParser);

  void excute();

  bool getBool(String key, {bool defaultValue = false}) =>
      argResults.getBool(key, defaultValue: defaultValue);

  String getString(String key, {String defaultValue = ''}) =>
      argResults.getString(key, defaultValue: defaultValue);
}
