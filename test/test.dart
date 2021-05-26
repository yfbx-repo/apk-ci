void main(List<String> args) {
  final list = args[0].split(RegExp(r'\r\n?|\n'));
  list.removeWhere((e) => e.trim().isEmpty);

  print(list);
}
