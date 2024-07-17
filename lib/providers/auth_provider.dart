// ignore_for_file: body_might_complete_normally_nullable

import 'dart:convert';

import 'package:face_app/models/auth.model.dart';
import 'package:face_app/views/Profile/profile.model.dart';
import 'package:face_app/views/Tabs/addAttendance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dio/api_response.dart';
import '../dio/dio_client.dart';
import '../dio/repo.dart';
import '../utils/navigation_service.dart';
import '../utils/slide_right_route.dart';
import '../Values/values.dart';
import '../views/LoginPage/loginscreen.dart';

class LoginProvider with ChangeNotifier {
  final Repo repo;
  final NavigationService ns;
  final SharedPreferences sharedPreferences;
  final DioClient dioClient;

  LoginProvider(
      {required this.repo,
      required this.ns,
      required this.sharedPreferences,
      required this.dioClient});

  //
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Future<void> checkVersion() async {
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   String buildNumber = packageInfo.buildNumber;
  //   ApiResponse res = await repo.getData(ApiStrings.getVersion);
  //   if (res.response != null && res.response!.statusCode == 200) {
  //     VersionModel versionModel = VersionModel.fromJson(res.response!.data);

  //     if (Platform.isAndroid) {
  //       androidGoto(buildNumber, versionModel);
  //     } else if (Platform.isIOS) {
  //       iosGoto(buildNumber, versionModel);
  //     }
  //   } else {
  //     Alerts.showError(res.error);
  //   }
  // }

  // void iosGoto(String buildNumber, VersionModel version) {
  //   if (version.iosServerDown) {
  //     Navigator.pushAndRemoveUntil(ns.getContext(), SlideRightRoute(page: AppMaintenance(message: "")), (route) => false);
  //   } else if (int.parse(buildNumber) >= version.iosSupportingVersion) {
  //     goto();
  //   } else {
  //     Navigator.pushAndRemoveUntil(ns.getContext(), SlideRightRoute(page: AppUpdate(message: "")), (route) => false);
  //   }
  // }

  // void androidGoto(String buildNumber, VersionModel version) {
  //   if (version.androidServerDown) {
  //     Navigator.pushAndRemoveUntil(ns.getContext(), SlideRightRoute(page: AppMaintenance(message: "")), (route) => false);
  //   } else if (int.parse(buildNumber) >= version.androidSupportingVersion) {
  //     goto();
  //   } else {
  //     Navigator.pushAndRemoveUntil(ns.getContext(), SlideRightRoute(page: AppUpdate(message: "")), (route) => false);
  //   }
  // }

  goto() async {
    Future.delayed(Duration.zero, () async {
      var res2 = await repo.getData(StringConst.PROFILE);
      // print(res2.response!.headers["content-type"]);
      if (res2.response != null && res2.response!.statusCode == 200) {
        if (res2.response!.headers["content-type"]!
            .contains("application/json")) {
          Profile profile = Profile.fromJson(res2.response?.data);
          sharedPreferences.setString("type", profile.type!);
          notifyListeners();
        } else {
          Navigator.pushAndRemoveUntil(ns.getContext(),
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      } else if (res2.error != "401") {
        if (kDebugMode) {
          print(res2.error);
        }
      }
    }).then((value) {
      // sharedPreferences.setString("type", "salesman");
      bool isLoggedIn = sharedPreferences.getBool('isLogged') ?? false;
      if (isLoggedIn) {
        var usertype = sharedPreferences.getString("type") ?? "";
        if (usertype == "general") {
          Navigator.pushAndRemoveUntil(
              ns.getContext(),
              SlideRightRoute(
                  page: const AddAttendance(
                usertype: true,
              )),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              ns.getContext(),
              SlideRightRoute(
                  page: const AddAttendance(
                usertype: false,
              )),
              (route) => false);
        }
      } else {
        Navigator.pushAndRemoveUntil(ns.getContext(),
            SlideRightRoute(page: const LoginScreen()), (route) => false);
      }
    });
  }

  Future<Profile?> login() async {
    String userId = userIdController.text;
    String password = passwordController.text;
    var data = {
      "client_id": "1",
      "client_secret": StringConst.CLIENT_SECRET,
      "grant_type": "password",
      "username": userId,
      "password": password
    };
    if (kDebugMode) {
      print(jsonEncode(data));
    }
    ApiResponse res = await repo.postData(StringConst.LOGIN, data: data);

    if (res.response != null && res.response!.statusCode == 200) {
      clearControllers();
      AuthRes loginRes = AuthRes.fromJson(res.response!.data);
      dioClient.dio.options.headers = {'Authorization': loginRes.accessToken};
      sharedPreferences.setString("token", loginRes.accessToken!);
      sharedPreferences.setBool("isLogged", true);
      Restart.restartApp();
    } else {
      Alerts.showError(res.error.toString());
    }
  }

  // Future<void> forgetPassword() async {
  //   String email = userIdController.text;
  //   ApiResponse res = await repo.postData(ApiStrings.forgetPassword, data: {'email': email});
  //   if (res.response != null && res.response!.statusCode == 200) {
  //     CommonRes commonRes = CommonRes.fromJson(res.response!.data);
  //     Alerts.showSuccess(commonRes.message);
  //   } else {
  //     Alerts.showError(res.error);
  //   }
  // }

  // Future<void> updatePassword() async {
  //   String currentPassword = currentPasswordController.text;
  //   String newPassword = newPasswordController.text;
  //   String confirmPassword = confirmPasswordController.text;

  //   if (newPassword != confirmPassword) {
  //     Alerts.showError("Enter valid password");
  //   } else {
  //     var data = {'currentPassword': currentPassword, 'newPassword': newPassword};
  //     ApiResponse res = await repo.postData(ApiStrings.updatePassword, data: data);
  //     if (res.response != null && res.response!.statusCode == 200) {
  //       CommonRes commonRes = CommonRes.fromJson(res.response!.data);
  //       Alerts.showSuccess(commonRes.message);
  //       logout();
  //     } else {
  //       Alerts.showError(res.error);
  //     }
  //   }
  // }

  // logout() {
  //   clearControllers();
  //   sharedPreferences.clear();
  //   Navigator.pushAndRemoveUntil(ns.getContext(), SlideRightRoute(page: const LoginScreen()), (route) => false);
  // }

  void clearControllers() {
    userIdController.clear();
    passwordController.clear();
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }
}
