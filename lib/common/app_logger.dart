import 'package:logger/logger.dart';

class AppLogger {
  const AppLogger._();

  static final Logger _logger = Logger();

  static void d(String message) {
    _logger.d(message);
  }

  static Future<void> e(String message, dynamic exception, StackTrace stackTrace) async {
    _logger.e(message, exception);
  }
}
