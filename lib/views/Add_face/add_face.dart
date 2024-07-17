// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';

import 'package:face_app/Values/values.dart';
import 'package:face_app/custom/widgets/dialog.dart';
import 'package:face_app/custom/widgets/toast.dart';
import 'package:aws_rekognition_api/rekognition-2016-06-27.dart';
import 'package:aws_rekognition_api/rekognition-2016-06-27.dart' as aws;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../providers/employee_provider.dart';

final scaffoldKey = GlobalKey<ScaffoldState>();
XFile? imageFile;
const uuid = Uuid();

class EnrollmentStepper extends StatefulWidget {
  final bool usertype;
  final String userId;
  final String employeId;

  const EnrollmentStepper(
      {super.key,
      required this.userId,
      required this.employeId,
      required this.usertype});

  @override
  _EnrollmentStepperState createState() => _EnrollmentStepperState();
}

class _EnrollmentStepperState extends State<EnrollmentStepper> {
  int currentStep = 0;
  final List<Step> steps = [];
  final ImagePicker _imagePicker = ImagePicker();
  String? collectionId;
  final bool _step3Success = true;

  // final _storage = FirebaseStorage.instanceFor();
  final rekognition = Rekognition(
      region: StringConst.REGION,
      credentials: AwsClientCredentials(
        accessKey: StringConst.ACCESS_KEY,
        secretKey: StringConst.SECRET_KEY,
      ));

  @override
  void initState() {
    super.initState();
    // createTable();
    // Initialize the steps
    for (int i = 0; i < 3; i++) {
      steps.add(
        Step(
          title: Text('Face ${i + 1}'),
          isActive: currentStep == i,
          content: Column(
            children: [
              Visibility(
                visible: _step3Success,
                child: ElevatedButton(
                  onPressed: () {
                    // capture3Photos(widget.userId);
                    _captureAndEnrollImage(i);
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Capture and Enroll Image'),
                    ],
                  ),
                ),
              ),
              // Add a widget to display captured image here
            ],
          ),
        ),
      );
    }
  }

  Future<void> _captureAndEnrollImage(int step) async {
    uuid.v4();
    Dialogs.showLoading();
    EmployeeProvider employee =
        Provider.of<EmployeeProvider>(context, listen: false);
    try {
      imageFile = await _imagePicker.pickImage(source: ImageSource.camera);
      if (imageFile == null) {
        if (kDebugMode) {
          print('Image not picked');
        }
        return;
      }
      if (kDebugMode) {
        print("step--$step");
      }
      final imageBytes = File(imageFile!.path).readAsBytesSync();

      String trimmedEmployeId = widget.employeId.replaceAll(' ', '_');
      final indexFacesResponse = await rekognition.indexFaces(
        collectionId: StringConst.GROUP_ID, // Use the collection ID
        image: aws.Image(bytes: Uint8List.fromList(imageBytes)),
        externalImageId:
            "${StringConst.GROUP_ID}${widget.userId}.$trimmedEmployeId",
      );
      if (step == 0) {
        // await rekognition.createCollection(collectionId: StringConst.GROUP_ID);
        // final collectionResponse = await rekognition.describeCollection(
        //     collectionId: StringConst.GROUP_ID);
        // print("res$collectionResponse");

        employee.setPersonId(
            employeeid: widget.userId,
            usertype: widget.usertype,
            personId: "${StringConst.GROUP_ID}${widget.userId}");
      }
      if (indexFacesResponse.faceRecords!.isNotEmpty) {
        indexFacesResponse.faceRecords?.forEach((element) {
          if (kDebugMode) {
            print('Face ID: ${element.face!.faceId}');
          }
          employee.addFaceId(
              usertype: widget.usertype,
              employeeid: widget.userId,
              faceId: '${element.face!.faceId}');
        });
      }
      if (currentStep != 2) {
        setState(() {
          imageFile = null;
        });
      }
      if (kDebugMode) {
        print('Current step: $currentStep');
      }
      // Move to the next step
      if (currentStep < steps.length - 1) {
        setState(() {
          currentStep++;
        });
      }
      Navigator.pop(context);
    } catch (e) {
      // Display a user-friendly error message
      Navigator.pop(context);
      if (kDebugMode) {
        print('Error: $e');
      }
      showErrorDialog(
          'An error occurred while enrolling the face. Please try again.');
      setState(() {
        imageFile = null;
      });
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDarkColor,
        elevation: 0,
        title: const Text('Add Face'),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Iconsax.arrow_left_1),
        ),
      ),
      body: Stepper(
        steps: steps,
        currentStep: currentStep,
        onStepContinue: () {
          if (imageFile != null) {
            if (currentStep == 2) {
              Dialogs.showLoading();
              Future.delayed(
                      const Duration(seconds: 3), () => Navigator.pop(context))
                  .then((value) => Navigator.pop(context));
              // Navigator.pop(context);
            } else if (currentStep < steps.length - 1) {
              setState(() {
                currentStep++;
              });
            }
          } else {
            toast(
                context: context,
                txt: 'Add Face ${currentStep + 1}',
                color: Colors.red.shade800);
          }
        },
        // onStepCancel: () {
        //   if (currentStep > 0) {
        //     setState(() {
        //       currentStep--;
        //     });
        //   }
        // },
      ),
    ));
  }
}
