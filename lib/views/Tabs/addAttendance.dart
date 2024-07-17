// ignore_for_file: use_build_context_synchronously, avoid_print, unnecessary_null_comparison, file_names

import 'dart:io';

import 'package:face_app/Values/values.dart';
import 'package:face_app/custom/widgets/custom_text.dart';
import 'package:face_app/custom/widgets/custom_textfield.dart';
import 'package:face_app/custom/widgets/dialog.dart';
import 'package:face_app/custom/widgets/systempadding.dart';
import 'package:face_app/providers/employee_provider.dart';
import 'package:face_app/utils/enums.dart';
import 'package:face_app/utils/salesman_camera.dart';
import 'package:face_app/utils/search_facecamera.dart' as facerec;
import 'package:face_app/views/Employees/employees.dart';
import 'package:face_app/views/Profile/profile.dart';
import 'package:aws_rekognition_api/rekognition-2016-06-27.dart' as aws;
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
// import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AddAttendance extends StatefulWidget {
  final bool usertype;

  const AddAttendance({
    super.key,
    required this.usertype,
  });

  @override
  State<AddAttendance> createState() => _AddAttendanceState();
}

class _AddAttendanceState extends State<AddAttendance> {
  final rekognition = aws.Rekognition(
      region: StringConst.REGION,
      credentials: aws.AwsClientCredentials(
        accessKey: StringConst.ACCESS_KEY,
        secretKey: StringConst.SECRET_KEY,
      ));
  @override
  void initState() {
    super.initState();
    fetchPosition(context);
  }

  Future<void> fetchPosition(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(msg: 'Location permission is required.');
      }
    }

    if (!serviceEnabled) {
      bool locationSettingsOpened = await Geolocator.openLocationSettings();
      if (!locationSettingsOpened) {
        Fluttertoast.showToast(msg: 'Failed to open location settings.');
      }
    }
    // Get the current position.
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Update the position provider.
    final positionProvider =
        Provider.of<EmployeeProvider>(context, listen: false);
    print(currentPosition.latitude);
    positionProvider.currentPosition = currentPosition;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<EmployeeProvider>(builder: (context, provider, child) {
      return SafeArea(
          child: Scaffold(
              appBar: AppBar(
                  backgroundColor: AppColors.primaryDarkColor,
                  leadingWidth: 150,
                  toolbarHeight: 80,
                  actions: [
                    InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EmployeeListView(
                                        usertype: widget.usertype,
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor:
                                    AppColors.white10.withOpacity(.3),
                                child: CircleAvatar(
                                    backgroundColor:
                                        AppColors.white.withOpacity(.4),
                                    child: const Icon(
                                      Iconsax.activity,
                                      color: AppColors.white,
                                    )),
                              ),
                              // const SizedBox(
                              //   width: 10,
                              // )
                            ],
                          ),
                        )),
                    // const SizedBox(
                    //   width: 10,
                    // ),
                    InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProfileWidget()));
                        },
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              radius: 28,
                              backgroundColor:
                                  AppColors.white10.withOpacity(.3),
                              child: CircleAvatar(
                                  backgroundColor:
                                      AppColors.white.withOpacity(.4),
                                  child: const Icon(
                                    Iconsax.setting_2,
                                    color: AppColors.white,
                                  )),
                            ),
                          ],
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                  leading: const Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      customText(
                        text: "COREMETAL ",
                        id: 0,
                        textSize: 23,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                  bottom: widget.usertype == true
                      ? PreferredSize(
                          preferredSize: Size(size.width, 50),
                          child: AppBar(
                            centerTitle: true,
                            toolbarHeight: 45,
                            backgroundColor: AppColors.blue,
                            elevation: 0,
                            title: const customText(
                              text: "Attendance",
                              id: 1,
                              color: AppColors.primaryDarkColor,
                            ),
                          ))
                      : PreferredSize(
                          preferredSize: Size(size.width, 50),
                          child: AppBar(
                            centerTitle: true,
                            toolbarHeight: 45,
                            backgroundColor: AppColors.white,
                            elevation: 0,
                            title: ToggleSwitch(
                              minWidth: size.width,
                              customTextStyles: const [
                                TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600),
                                TextStyle(
                                    fontSize: 18.0, fontWeight: FontWeight.w600)
                              ],
                              cornerRadius: 8.0,
                              initialLabelIndex:
                                  provider.inMeeting == false ? 0 : 1,
                              changeOnTap: true,
                              totalSwitches: 2,
                              activeBgColor: const [
                                AppColors.primaryDarkColor,
                                AppColors.primaryColor
                              ],
                              labels: const ['Attendance', 'Meeting'],
                              onToggle: (index) {
                                print('switched to: $index');
                                if (index == 0) {
                                  provider.inMeeting = false;
                                } else {
                                  provider.inMeeting = true;
                                }
                              },
                            ),
                          ))),
              body: widget.usertype == true
                  ? facerec.SmartFaceCamera(
                      imageResolution: ImageResolution.low,
                      autoCapture: false,
                      showFlashControl: false,
                      showCameraLensControl: false,
                      defaultCameraLens: CameraLens.front,
                      message: '',
                      onCheckin: (File? image) async {
                        await Haptics.vibrate(HapticsType.success).then(
                            (value) => verifyEmployeecheckin(
                                context, XFile(image!.path), true));
                      },
                      onCheckout: (File? image) async {
                        await Haptics.vibrate(HapticsType.success).then(
                            (value) => verifyEmployeecheckin(
                                context, XFile(image!.path), false));
                      },
                    )
                  : SalesmanCamera(
                      imageResolution: ImageResolution.low,
                      autoCapture: false,
                      showFlashControl: false,
                      showCameraLensControl: false,
                      defaultCameraLens: CameraLens.front,
                      message: '',
                      onCheckin: (File? image) async {
                        await Haptics.vibrate(HapticsType.success).then(
                            (value) => provider.inMeeting == false
                                ? verifyEmployeecheckin(
                                    context, XFile(image!.path), true)
                                : verifyEmployeecheckin(
                                    context, XFile(image!.path), true,
                                    inMeeting: true));
                      },
                      onCheckout: (File? image) async {
                        await Haptics.vibrate(HapticsType.success).then(
                            (value) => provider.inMeeting == false
                                ? verifyEmployeecheckin(
                                    context, XFile(image!.path), false)
                                : verifyEmployeecheckin(
                                    context, XFile(image!.path), false,
                                    inMeeting: true));
                      },
                    )));
    });
  }

  Future<void> verifyEmployeecheckin(
      BuildContext context, XFile image, bool checkin,
      {bool inMeeting = false}) async {
    EmployeeProvider employee =
        Provider.of<EmployeeProvider>(context, listen: false);
    if (image == null) {
      print('Image capture canceled.');
      return;
    }
    final imageBytes = File(image.path).readAsBytesSync();
    // try {
    Dialogs.showLoading();
    final searchFacesResponse = await rekognition.searchFacesByImage(
      collectionId: StringConst.GROUP_ID,
      image: aws.Image(bytes: Uint8List.fromList(imageBytes)),
    );
    //  ------------------------------------------------------------------->-
    if (searchFacesResponse.faceMatches!.isNotEmpty) {
      print('Employees face verified successfully');
      String inputString =
          searchFacesResponse.faceMatches!.first.face!.externalImageId!;
      int decimalPointIndex = inputString.indexOf(".");
      String personId = inputString.substring(0, decimalPointIndex);
      String emplyeId =
          inputString.substring(decimalPointIndex + 1).replaceAll('_', ' ');
      if (inMeeting == false) {
        if (checkin == true) {
          if (employee.currentPosition?.latitude != null) {
            if (widget.usertype == true) {
              employee.checkIn(
                  employeeid: emplyeId,
                  context: context,
                  personid: personId,
                  file: image,
                  pos: employee.currentPosition!,
                  action: checkin);
            } else {
              employee.salesmanCheckIn(
                  personid: personId,
                  context: context,
                  file: image,
                  pos: employee.currentPosition!,
                  action: checkin);
            }
          } else {
            fetchPosition(context);
          }
        } else {
          if (employee.currentPosition?.latitude != null) {
            if (widget.usertype == true) {
              employee.checkout(
                  employeeid: emplyeId,
                  context: context,
                  personid: personId,
                  file: image,
                  pos: employee.currentPosition!,
                  action: checkin);
            } else {
              employee.salesmanCheckout(
                  personid: personId,
                  context: context,
                  file: image,
                  pos: employee.currentPosition!,
                  action: checkin);
            }
          } else {
            fetchPosition(context);
          }
        }
      } else {
        if (checkin == true) {
          if (employee.currentPosition?.latitude != null) {
            employee.meetingCheckIn(
                file: image,
                pos: employee.currentPosition!,
                personid: personId,
                context: context,
                action: true);
          } else {
            fetchPosition(context);
          }
        } else {
          if (employee.currentPosition?.latitude != null) {
            showcheckoutform(employee, image, context,
                employee.currentPosition!, personId, checkin);
          } else {
            fetchPosition(context);
          }
        }
      }
    } else {
      print('Employees face verification failed');
      QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: "User not Found !",
              text: "User is not registered",
              animType: QuickAlertAnimType.slideInDown)
          .then((value) => Navigator.pop(context));
    }
    // } catch (e) {
    //   print('Employees face verification failed');
    //   QuickAlert.show(
    //           context: context,
    //           type: QuickAlertType.error,
    //           title: "User not Found !",
    //           text: "$e",
    //           animType: QuickAlertAnimType.slideInDown)
    //       .then((value) => Navigator.pop(context));
    // }
  }

  Future<void> showcheckoutform(EmployeeProvider employee, XFile image,
      BuildContext context, Position pos, String personid, bool checkin) async {
    showGeneralDialog(
        context: context,
        barrierLabel: "",
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (filtercontext, __, ___) {
          return StatefulBuilder(builder: (contxt, setState) {
            return SystemPadding(
                child: Center(
                    child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(5)),
              child: Material(
                color: AppColors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const customText(
                      id: 1,
                      text: "Check Out",
                      color: AppColors.primaryDarkColor,
                      weight: FontWeight.bold,
                      textSize: 22,
                    ),
                    const Divider(),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: customText(
                        text: "Customer Name",
                        id: 1,
                        textSize: 17,
                      ),
                    ),
                    Row(children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Material(
                            color: AppColors.white,
                            child: CustomTextFormField(
                              maxlines: 1,
                              id: 0,
                              controller: employee.custnameController,
                              labelColor:
                                  const Color.fromRGBO(173, 173, 173, 1),
                              hintText: "Enter customer name",
                              hintColor: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ]),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: customText(
                        text: "Purpose",
                        id: 1,
                        textSize: 17,
                      ),
                    ),
                    Row(children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Material(
                            color: AppColors.white,
                            child: CustomTextFormField(
                              maxlines: 1,
                              id: 0,
                              controller: employee.purposeController,
                              labelColor: AppColors.hint2,
                              hintText: "Enter purpose",
                              hintColor: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ]),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: customText(
                        text: "meeting Notes",
                        id: 1,
                        textSize: 17,
                      ),
                    ),
                    Row(children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Material(
                            color: AppColors.white,
                            child: CustomTextFormField(
                              maxlines: 3,
                              id: 0,
                              controller: employee.mnotesController,
                              labelColor: AppColors.hint2,
                              hintText: "Enter Notes",
                              hintColor: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                backgroundColor:
                                    AppColors.primaryColor.withOpacity(.4),
                                fixedSize: const Size(100, 50),
                              ),
                              onPressed: () {
                                if (employee.custnameController.text.isEmpty) {
                                  Alerts.showError(
                                      "Customer name field is required !");
                                } else if (employee
                                    .purposeController.text.isEmpty) {
                                  Alerts.showError(
                                      "Purpose field is required !");
                                } else if (employee
                                    .mnotesController.text.isEmpty) {
                                  Alerts.showError("Notes field is required !");
                                } else {
                                  Navigator.pop(contxt, true);
                                  employee.meetingCheckout(
                                      file: image,
                                      pos: pos,
                                      personid: personid,
                                      context: context,
                                      action: checkin);
                                }
                              },
                              child: const Row(children: [
                                Icon(Iconsax.arrow_down_24,
                                    color: AppColors.white),
                                SizedBox(
                                  width: 10,
                                ),
                                customText(
                                  text: 'Check Out',
                                  id: 1,
                                  color: AppColors.black,
                                ),
                              ])),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            )));
          });
        });
  }
}
