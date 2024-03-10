import 'package:intl/intl.dart';

String formatDate(String st) {
  return DateFormat('dd.MM.yy HH:mm').format(DateTime.parse(st));
}

String getContent(String input) {
  int closingBracketIndex = input.lastIndexOf(']');
  int openingBracketIndex = input.lastIndexOf('[');
  if (closingBracketIndex != -1 && openingBracketIndex != -1) {
    return input.substring(0, openingBracketIndex);
  } else {
    return input;
  }
}
