class AnsiColor {
  // ANSI escape codes
  static const String _reset = '\x1B[0m';
  static const String _yellow = '\x1B[33m';
  static const String _red = '\x1B[31m';

  /// A regular expression to find and remove ANSI escape codes from a string.
  static final _ansiRegex = RegExp(r'\x1B\[[0-9;]*m');

  /// Wraps the given [text] in yellow color codes.
  String yellow(String text) => '$_yellow$text$_reset';

  /// Wraps the given [text] in red color codes.
  String red(String text) => '$_red$text$_reset';

  /// Strips all ANSI color codes from the [text].
  /// This is useful for calculating the visible length of a string.
  static String strip(String text) => text.replaceAll(_ansiRegex, '');
}