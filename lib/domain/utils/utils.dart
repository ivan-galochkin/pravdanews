import 'package:intl/intl.dart';

abstract class Utils {
  String getContent(String input);

  String formatDate(String st);
}

class UtilsImpl implements Utils {
  @override
  String formatDate(String st) {
    return DateFormat('dd.MM.yy HH:mm').format(DateTime.parse(st));
  }

  @override
  String getContent(String input) {
    int closingBracketIndex = input.lastIndexOf(']');
    int openingBracketIndex = input.lastIndexOf('[');
    if (closingBracketIndex != -1 && openingBracketIndex != -1) {
      return input.substring(0, openingBracketIndex);
    } else {
      return input;
    }
  }
}

class MemoryIdStorage {
  Map<int, bool> idsMap = {};

  void addId(int id) {
    idsMap[id] = true;
  }

  void deleteId(int id) {
    idsMap[id] = false;
  }
}
