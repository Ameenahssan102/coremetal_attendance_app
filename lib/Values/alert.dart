part of 'values.dart';

class Alerts {
  static showError(String text) {
    return showSimpleNotification(Text(text), background: Colors.red.shade800);
  }

  static showError2(String text) {
    return showSimpleNotification(Text(text), background: Colors.red.shade800);
  }

  static showSuccess(String text) {
    return showSimpleNotification(Text(text), background: AppColors.green);
  }

  static show(int type, String text) {
    if (type == 1) {
      showSuccess(text);
    } else {
      showError(text);
    }
  }
}
