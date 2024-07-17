// ignore_for_file: library_private_types_in_public_api

import 'package:face_app/Values/values.dart';
import 'package:face_app/custom/widgets/custom_text.dart';
import 'package:face_app/custom/widgets/profiletile.dart';
import 'package:face_app/providers/employee_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String versionName = "";

  Future<void> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      versionName = "${packageInfo.version}-${packageInfo.buildNumber}";
    });
  }

  @override
  void initState() {
    super.initState();
    getPackageInfo();
    Provider.of<EmployeeProvider>(context, listen: false).getProfile();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<EmployeeProvider>(builder: (context, provider, child) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          key: scaffoldKey,
          appBar: AppBar(
            backgroundColor: AppColors.primaryDarkColor,
            elevation: 0,
            title: const customText(
              text: "Profile ",
              id: 0,
              textSize: 23,
              color: AppColors.white,
            ),
            leading: InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(Iconsax.arrow_left_1, color: AppColors.white),
            ),
          ),
          body: Align(
            alignment: const AlignmentDirectional(0.00, 0.00),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  color: AppColors.white,
                  width: 140.0,
                  child: Stack(
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(0.00, 0.00),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 12.0, 0.0, 0.0),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor:
                                AppColors.primaryDarkColor.withOpacity(.1),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: AppColors.white.withOpacity(.4),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(90),
                                child: Image.network(
                                  'https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 16.0, 0.0, 12.0),
                    child: customText(
                      text: provider.profile != null
                          ? provider.profile!.name!
                          : 'User Name',
                      id: 1,
                      textSize: 23,
                      weight: FontWeight.bold,
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 30.0, 0.0, 0.0),
                    child: Container(
                      width: double.infinity,
                      height: 400.0,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3.0,
                            color: Color.fromARGB(51, 58, 51, 51),
                            offset: Offset(0.0, -1.0),
                          )
                        ],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0.0),
                          bottomRight: Radius.circular(0.0),
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16.0, 30.0, 16.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 12.0),
                                        child: customText(
                                            text: 'Settings',
                                            color: AppColors.primaryDarkColor,
                                            textSize: 22,
                                            weight: FontWeight.bold,
                                            id: 1),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Center(
                                        child: Container(
                                          color: AppColors.hint.withOpacity(.2),
                                          height: 0.5,
                                        ),
                                      ))
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 3),
                                    child: ProfileTile(
                                        navigateto: () async {
                                          // const aboutus =
                                          //     "https://care4consulting.co.uk/about";
                                          // await canLaunchUrlString(aboutus)
                                          //     ? launchUrlString(aboutus)
                                          //     : print("error while opening aboutus");
                                        },
                                        icon: Iconsax.information,
                                        tiletext: "About Us"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 3),
                                    child: ProfileTile(
                                        navigateto: () async {
                                          // const terms =
                                          //     "https://care4consulting.co.uk/terms_and_conditions.html";
                                          // await canLaunchUrlString(terms)
                                          //     ? launchUrlString(terms)
                                          //     : print(
                                          //         "error while opening terms&condition");
                                        },
                                        icon: Iconsax.global,
                                        tiletext: "Terms & Conditions"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 3),
                                    child: ProfileTile(
                                        navigateto: () async {
                                          // const Policy =
                                          //     "https://care4consulting.co.uk/privacy_policy.html";
                                          // await canLaunchUrlString(Policy)
                                          //     ? launchUrlString(Policy)
                                          //     : print(
                                          //         "error while opening Policy");
                                        },
                                        icon: Iconsax.lock,
                                        tiletext: "Privacy Policy"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 3),
                                    child: ProfileTile(
                                        navigateto: () async {},
                                        icon: Iconsax.verify,
                                        tiletext: "Change Password"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 3),
                                    child: ProfileTile(
                                        navigateto: () async {
                                          // const aboutus =
                                          //     "https://care4consulting.co.uk/contact";
                                          // await canLaunchUrlString(aboutus)
                                          //     ? launchUrlString(aboutus)
                                          //     : print(
                                          //         "error while opening aboutus");
                                        },
                                        icon: Iconsax.call,
                                        tiletext: "Contact Us"),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        backgroundColor: AppColors.primaryColor,
                                        fixedSize: Size(size.width, 50),
                                      ),
                                      onPressed: () {
                                        provider.logout();
                                      },
                                      child: const Row(children: [
                                        Icon(Iconsax.logout,
                                            color: AppColors.white),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        customText(
                                          text: 'Log out',
                                          id: 1,
                                          color: AppColors.white,
                                        ),
                                      ])),
                                  const SizedBox(height: 24.0),
                                  Center(
                                      child: customText(
                                          id: 1,
                                          text: "V$versionName",
                                          color: Colors.black38)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
