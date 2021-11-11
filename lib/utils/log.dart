import 'dart:math';

import 'package:logger/logger.dart';

class Log {
  static final log = Logger();

  static void d(dynamic message) {
    log.d(message);
  }

  static void e(dynamic message) {
    log.e(message);
  }

  static void v(dynamic message) {
    log.v(message);
  }

  static void i(dynamic message) {
    log.i(message);
  }
}
