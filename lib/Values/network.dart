// ignore_for_file: prefer_const_constructors, camel_case_types, unrelated_type_equality_checks

part of 'values.dart';

class networkConnectivity {
  static network(BuildContext context) async {
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      return showSimpleNotification(
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            CircleAvatar(
                backgroundColor: Colors.grey.shade100,
                radius: 14,
                child: const Icon(
                  Icons.wifi_off_outlined,
                  color: Colors.black,
                )),
            const SizedBox(
              width: 20,
            ),
            customText(
              text: "No Internet Connection",
              color: AppColors.white,
              id: 1,
            ),
          ]),
          background: AppColors.dark);
    }
  }
}
