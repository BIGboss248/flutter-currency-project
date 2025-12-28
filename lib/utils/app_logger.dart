import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

late Logger logger;
final printer = PrettyPrinter(
  colors: true,
  noBoxingByDefault: false,
  printEmojis: true,
  levelColors: {
    /* 
    For some reason Ansi color won't show as their colors in terminal so had to change
    */
    Level.debug: AnsiColor.fg(33), //Blue
    Level.info: AnsiColor.fg(34), //Green
    Level.warning: AnsiColor.fg(166), //Yellow
    Level.error: AnsiColor.fg(160), //Red
  },
);

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
      printer: printer,
      output: MultiOutput([ConsoleOutput(), FileOutput(file: logFile)]),
    );

    logger.i('Logger initialized. Logs path: ${logFile.path}');
  } catch (e, st) {
    print('Failed to initialize logger: $e');
    print(st);
    // Fallback to console-only logger
    logger = Logger(printer: printer, output: MultiOutput([ConsoleOutput()]));
  }
}
