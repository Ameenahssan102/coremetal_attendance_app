// ignore_for_file: deprecated_member_use

import 'package:face_app/Values/values.dart';
import 'package:face_app/custom/widgets/custom_text.dart';
import 'package:face_app/custom/widgets/systempadding.dart';
import 'package:face_app/utils/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';

class Dialogs {
  static const spinkit = SpinKitRotatingPlain(
    color: AppColors.blue,
    size: 50.0,
    duration: Duration(milliseconds: 300),
  );
  static showLoading() {
    showDialog(
      barrierColor: Colors.black.withOpacity(0.7),
      barrierDismissible: true,
      context: GetIt.I<NavigationService>().getContext(),
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: const Dialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: spinkit,
          ),
        );
      },
    );
  }

  static showLoading2({
    required BuildContext context,
  }) {
    showDialog(
      barrierColor: Colors.black.withOpacity(0.7),
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: Dialog(
            insetAnimationDuration: const Duration(seconds: 2),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Lottie.asset('assets/lottie/faceid.json'),
          ),
        );
      },
    );
  }

  static showAlertDialog(
      {required BuildContext context,
      required String title,
      required Widget subTitle,
      required VoidCallback yesClick}) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: SystemPadding(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                customText(
                  id: 1,
                  text: title,
                  color: AppColors.primaryDarkColor,
                  weight: FontWeight.bold,
                  textSize: 19,
                ),
                const Divider(),
              ],
            ),
          ),
        ),
        actions: [
          subTitle,
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("NO")),
          TextButton(
              onPressed: () {
                Navigator.pop(context, true);
                yesClick();
              },
              child: const Text("YES")),
        ],
      ),
    );
  }

  static showError({
    required BuildContext context,
  }) {
    showDialog(
      barrierColor: Colors.black.withOpacity(0.7),
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: Dialog(
            insetAnimationDuration: const Duration(seconds: 2),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Lottie.asset('assets/lottie/error.json'),
          ),
        );
      },
    );
  }

  static showDialogBox(
      {required BuildContext context,
      required String title,
      String? subTitle,
      required VoidCallback yesClick}) async {
    return showDialog<bool>(
      context: context,
      builder: (contxt) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            customText(
              text: title,
              id: 1,
              color: AppColors.primaryDarkColor,
              weight: FontWeight.bold,
              textSize: 19,
            ),
            const Divider(
              color: AppColors.primaryDarkColor,
            ),
          ],
        ),
        content: customText(
          text: subTitle ?? "",
          id: 1,
          color: AppColors.hint,
          weight: FontWeight.w600,
          textSize: 16,
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(contxt, true);
              },
              child: const Text("YES")),
        ],
      ),
    );
  }
}
