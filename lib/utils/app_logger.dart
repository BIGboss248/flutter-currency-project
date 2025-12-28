import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as developer;
import 'package:package_info_plus/package_info_plus.dart';

late AppLogger logger;

/// Initialize a file logger by creating the log file in the app's documents directory.
/// If failed or empty logger will only log to devtools
///! Call this in main() before using the logger.
Future<void> initializeLogger(PrettyPrinter? printer) async {
  printer ??= PrettyPrinter(
    colors: false,
    noBoxingByDefault: true,
    printEmojis: false,
  );
  try {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName; // e.g., "My Awesome App"
    String sanitizedAppName = appName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
    Directory documentsDir = await getApplicationDocumentsDirectory();
    final logsDir = Directory('${documentsDir.path}/$sanitizedAppName/logs');
    developer.log(
      "log directory is ${logsDir.path}",
      name: "logger",
      level: 800,
    );
    // Create logs directory if it doesn't exist
    if (!await logsDir.exists()) {
      developer.log(
        "Creating directory ${logsDir.path}",
        name: "logger",
        level: 800,
      );
      await logsDir.create(recursive: true);
    }

    final logFile = File('${logsDir.path}/logs.txt');
      developer.log(
        "Logs are stored at ${logsDir.path}/logs.txt",
        name: "logger",
        level: 800,
      );
    logger = AppLogger(logFile: logFile, printer: printer);
  } catch (e) {
    developer.log(
      "Error creating a file logger",
      error: e,
      name: "logger",
      level: 1000,
    );
    logger = AppLogger();
  }
}

/// A custom app logger to log to both console and file.
/// To log to a file I use logger/logger.dart
/// For console and devtools logging I use dart:developer
class AppLogger {
  File? logFile;
  Logger? fileLogger;
  static const debugLevel = 500;
  static const infoLevel = 800;
  static const warningLevel = 900;
  static const errorLevel = 1000;
  static const fatalLevel = 1200;
  int sequenceNumber = 0;

  AppLogger({File? logFile, PrettyPrinter? printer}) {
    if (logFile != null) {
      if (printer != null) {
        fileLogger = Logger(
          printer: printer,
          output: FileOutput(file: logFile),
        );
      } else {
        printer = PrettyPrinter(
          colors: false,
          noBoxingByDefault: true,
          printEmojis: false,
        );
        fileLogger = Logger(
          printer: printer,
          output: FileOutput(file: logFile),
        );
      }
    }
  }

  void i(
    String message, {
    String? logName,
    DateTime? logTime,
    int logLevel = infoLevel,
  }) {
    logTime = DateTime.now();
    if (logName == null) {
      developer.log(
        message,
        time: logTime,
        level: logLevel,
        sequenceNumber: ++sequenceNumber,
      );
    } else {
      developer.log(
        message,
        time: logTime,
        level: logLevel,
        name: logName,
        sequenceNumber: ++sequenceNumber,
      );
      if (fileLogger != null) {
        fileLogger!.i(message);
      }
    }
  }

  void d(
    String message, {
    String? logName,
    DateTime? logTime,
    int logLevel = debugLevel,
  }) {
    logTime = DateTime.now();
    if (logName == null) {
      developer.log(
        message,
        time: logTime,
        level: logLevel,
        sequenceNumber: ++sequenceNumber,
      );
    } else {
      developer.log(
        message,
        time: logTime,
        level: logLevel,
        name: logName,
        sequenceNumber: ++sequenceNumber,
      );
      if (fileLogger != null) {
        fileLogger!.d(message);
      }
    }
  }

  void w(
    String message, {
    String? logName,
    DateTime? logTime,
    int logLevel = warningLevel,
  }) {
    logTime = DateTime.now();
    if (logName == null) {
      developer.log(
        message,
        time: logTime,
        level: logLevel,
        sequenceNumber: ++sequenceNumber,
      );
    } else {
      developer.log(
        message,
        time: logTime,
        level: logLevel,
        name: logName,
        sequenceNumber: ++sequenceNumber,
      );
      if (fileLogger != null) {
        fileLogger!.w(message);
      }
    }
  }

  void e(
    String message, {
    String? logName,
    DateTime? logTime,
    int logLevel = errorLevel,
  }) {
    logTime = DateTime.now();
    if (logName == null) {
      developer.log(
        message,
        time: logTime,
        level: logLevel,
        sequenceNumber: ++sequenceNumber,
      );
    } else {
      developer.log(
        message,
        time: logTime,
        level: logLevel,
        name: logName,
        sequenceNumber: ++sequenceNumber,
      );
      if (fileLogger != null) {
        fileLogger!.e(message);
      }
    }
  }

  void f(
    String message, {
    String? logName,
    DateTime? logTime,
    int logLevel = fatalLevel,
  }) {
    logTime = DateTime.now();
    if (logName == null) {
      developer.log(
        message,
        time: logTime,
        level: logLevel,
        sequenceNumber: ++sequenceNumber,
      );
    } else {
      developer.log(
        message,
        time: logTime,
        level: logLevel,
        name: logName,
        sequenceNumber: ++sequenceNumber,
      );
      if (fileLogger != null) {
        fileLogger!.f(message);
      }
    }
  }
}
