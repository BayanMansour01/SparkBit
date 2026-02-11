import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LoggerService {
  /// Writes log message to a safe writable location on the device
  static Future<void> logToFile(String message) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/api_logs.txt');

      final time = DateTime.now().toString().split('.').first;
      final logEntry = '[$time] $message\n';

      // 1. Write for In-App viewing
      await file.writeAsString(logEntry, mode: FileMode.append, flush: true);

      // 2. Print for our background capture script (shows up in project /logs folder)
      print('GLOBAL_LOG: $logEntry');
    } catch (e) {
      print('Failed to write to file: $e');
    }
  }

  // Stubs for UI compatibility
  static Future<String> readLogs() async => "Logs are in logs/api_logs.txt";
  static Future<void> clearLogs() async {
    final file = File('logs/api_logs.txt');
    if (file.existsSync()) file.deleteSync();
  }
}
