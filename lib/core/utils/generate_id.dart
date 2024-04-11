import 'dart:math';

import 'package:intl/intl.dart';

const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
Random random = Random();
String generateId() {
  String randomLetters =
      List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  String now = (DateTime.now().millisecondsSinceEpoch / 1000)
      .round()
      .toString()
      .substring(7);
  String formatted =
      DateFormat('yyMMdhmm', 'en_US').format(DateTime.now()).substring(1);
  return formatted + now + randomLetters;
}
