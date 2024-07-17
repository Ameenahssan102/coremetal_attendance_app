import 'package:flutter/foundation.dart';

class PrintUtil {
  static void printImportant(data) {
    if (kDebugMode) {
      print(data);
    }
  }

  static void printLog(String str) {
    if (kDebugMode) {
      print(str);
    }
  }
}
