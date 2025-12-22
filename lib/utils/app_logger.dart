import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

late Logger logger;

/// Initialize the logger with file and console output.
///! Call this in main() before using the logger.
/// Example: await initializeLogger();
Future<void> initializeLogger() async {
  try {
    // Get platform-specific documents directory
    final documentsDir = await getApplicationDocumentsDirectory();
    final logsDir = Directory('${documentsDir.path}/logs');

    // Create logs directory if it doesn't exist
    if (!await logsDir.exists()) {
      await logsDir.create(recursive: true);
    }

    final logFile = File('${logsDir.path}/app_logger.txt');

    // Create logger with both console and file output
    logger = Logger(
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
      output: MultiOutput([ConsoleOutput(), FileOutput(file: logFile)]),
    );

    logger.i('Logger initialized. Logs path: ${logFile.path}');
  } catch (e, st) {
    print('Failed to initialize logger: $e');
    print(st);
    // Fallback to console-only logger
    logger = Logger(
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
      output: MultiOutput([ConsoleOutput()]),
    );
  }
}
