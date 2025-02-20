import 'package:intl/intl.dart';

String getLevel(int exp) {
  int grade = (exp / 999).ceil() + 1;
  return 'Lv. $grade';
}

String getNumberFormat(int number) => NumberFormat('#,###').format(number);
