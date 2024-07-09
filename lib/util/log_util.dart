// ignore_for_file: non_constant_identifier_names

import 'package:logger/logger.dart';


var _logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
  ),
);

logV(dynamic msg) {
  _logger.v(msg);
}

logD(dynamic msg) {
  _logger.d(msg);
}

logI(dynamic msg) {
  _logger.i(msg);
}

logW(dynamic msg) {
  _logger.w(msg);
}

logE(dynamic msg) {
  _logger.e(msg);
}

logWTF(dynamic msg) {
  _logger.wtf(msg);
}