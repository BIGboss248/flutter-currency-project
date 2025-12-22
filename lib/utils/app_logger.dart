import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(
    colors: true,
    noBoxingByDefault: true,
    printEmojis: true,
    levelColors: {
      Level.debug: AnsiColor.fg(33),
      Level.info: AnsiColor.fg(32),
      Level.warning: AnsiColor.fg(93),
      Level.fatal: AnsiColor.fg(31),
    },
  ),
  output: MultiOutput([ConsoleOutput(), MemoryOutput()]),
);
