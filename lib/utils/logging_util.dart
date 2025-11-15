import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class SimplePrinter extends LogPrinter {
  static final DateFormat _dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  final String _name;
  SimplePrinter(this._name);

  @override
  List<String> log(LogEvent event) {
    return ['[${_dateFormat.format(event.time)}]'
        ' [${_formatLevel(event.level)}]'
        ' [$_name] ${event.message}'];
  }

  String _formatLevel(Level level) {
    String strLevel = level.toString()
        .toUpperCase();
    strLevel = strLevel.replaceFirst('LEVEL.', '');
    return strLevel;
  }
}

class LoggingUtil {
  static void configure() {
    Logger.level = (kDebugMode) ? Level.debug : Level.info;
  }

  Logger? _logger;
  LoggingUtil(String name) {
    _logger = Logger(
      printer: SimplePrinter(name)
    );
  }

  void debug(String message) {
    _logger?.d(message);
  }

  void error(String message) {
    _logger?.e(message);
  }

  void info(String message) {
    _logger?.i(message);
  }

  void warn(String message) {
    _logger?.w(message);
  }
}