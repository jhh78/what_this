import 'dart:developer';

import 'package:intl/intl.dart';

String getLevel(int exp) {
  int grade = (exp / 999).ceil() + 1;
  return 'Lv. $grade';
}

void showLog(Map<String, dynamic> object, Type className) {
  log('===================== $className ===========================');
  object.forEach((key, value) {
    log('$key: $value');
  });
  log('=============================================================');
}

String getNumberFormat(int number) => NumberFormat('#,###').format(number);
