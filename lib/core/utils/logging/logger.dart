import 'package:logger/logger.dart';

class AppLoggerHelper{
  AppLoggerHelper._();
  static final Logger _logger = Logger(
    printer: PrettyPrinter(), 
    level: Level.debug,
  );

  static void debug(String message) {
    _logger.d(message);
  }

  static void info(String message) {
    _logger.i(message);
  }

  static void warning(String message) {
    _logger.w(message);
  }

  static void error(String message, [dynamic error]) {
    if (error != null) {
      _logger.e(message, error: error.toString(), stackTrace: StackTrace.current);
    } else {
      _logger.e(message, stackTrace: StackTrace.current);
    }
  }
}