// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:face_app/Values/values.dart';
import 'package:face_app/custom/widgets/custom_text.dart';
import 'package:face_app/custom/widgets/systempadding.dart';
import 'package:face_app/custom/widgets/toast.dart';
import 'package:face_app/models/employees.model.dart';
import 'package:aws_rekognition_api/rekognition-2016-06-27.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/employee_provider.dart';
import '../Add_face/add_face.dart';

class EmployeeListView extends StatefulWidget {
  final bool usertype;
  const EmployeeListView({super.key, required this.usertype});

  @override
  State<EmployeeListView> createState() => _EmployeeListViewState();
}

class _EmployeeListViewState extends State<EmployeeListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmployeeProvider>(context, listen: false)
          .getListOfEmployees();
    });
  }

  final rekognition = Rekognition(
      region: StringConst.REGION,
      credentials: AwsClientCredentials(
        accessKey: StringConst.ACCESS_KEY,
        secretKey: StringConst.SECRET_KEY,
      ));

  final RefreshController refreshCntrlr =
      RefreshController(initialRefresh: true);

  XFile? imageFile2;
  XFile? imageFile3;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<EmployeeProvider>(
        builder: (contxt1, employeeProvider, child) {
      return SafeArea(
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.primaryDarkColor,
                elevation: 0,
                title: const customText(
                  text: "List of Employees",
                  color: AppColors.white,
                  id: 1,
                ),
                leading: InkWell(
                  onTap: () => Navigator.pop(context),
                  child:
                      const Icon(Iconsax.arrow_left_1, color: AppColors.white),
                ),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 8.0, 16.0, 0.0),
                    child: TextFormField(
                        controller: employeeProvider.employeController,
                        obscureText: false,
                        decoration: const InputDecoration(
                          labelText: 'Search Employee by Name...',
                        ),
                        onChanged: (searchTerm) {
                          // Update the filtered list of employees.
                          employeeProvider.filteredEmployees = employeeProvider
                              .employees
                              .where((employee) => employee.name!
                                  .toLowerCase()
                                  .contains(searchTerm.toLowerCase()))
                              .toList();
                        }),
                  ),
                  Expanded(
                    child: SmartRefresher(
                        controller: refreshCntrlr,
                        onRefresh: () async {
                          final result = await Provider.of<EmployeeProvider>(
                                  context,
                                  listen: false)
                              .getListOfEmployees();
                          if (result != null) {
                            refreshCntrlr.refreshCompleted();
                          } else {
                            refreshCntrlr.refreshFailed();
                          }
                        },
                        child: employeeProvider.filteredEmployees != null
                            ? employeeProvider.filteredEmployees.isEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Center(
                                          child: customText(
                                            text:
                                                'No Employee registered yet !',
                                            id: 1,
                                            color:
                                                AppColors.hint.withOpacity(.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : ListView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    itemCount:
                                        employeeProvider.filteredEmployees !=
                                                null
                                            ? employeeProvider
                                                .filteredEmployees.length
                                            : 0,
                                    itemBuilder: (contxt, index) {
                                      final employee = employeeProvider
                                          .filteredEmployees[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onLongPress: () async {
                                            final sharedPreferences =
                                                await SharedPreferences
                                                    .getInstance();

                                            deleteFaceIds(
                                                employeeProvider,
                                                employee,
                                                rekognition,
                                                sharedPreferences,
                                                context);
                                          },
                                          onTap: () {
                                            if (employee.personId == null) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EnrollmentStepper(
                                                            usertype:
                                                                widget.usertype,
                                                            userId: employee.id
                                                                .toString(),
                                                            employeId: employee
                                                                .employeeId
                                                                .toString(),
                                                          ))).then((value) =>
                                                  employeeProvider
                                                      .getListOfEmployees());
                                            } else {
                                              toast(
                                                  context: context,
                                                  color: Colors.red.shade900,
                                                  txt:
                                                      '${employee.name} has already enrolled');
                                            }
                                          },
                                          child: Card(
                                            color: AppColors.white,
                                            elevation: 3,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ListTile(
                                                    leading: CircleAvatar(
                                                      radius: 28,
                                                      backgroundColor: AppColors
                                                          .primaryDarkColor
                                                          .withOpacity(.4),
                                                      child: CircleAvatar(
                                                          backgroundColor:
                                                              AppColors
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                      .01),
                                                          child: const Icon(
                                                            Iconsax.user,
                                                            color:
                                                                AppColors.white,
                                                          )),
                                                    ),
                                                    title: customText(
                                                      text: employee.name!,
                                                      id: 1,
                                                    ),
                                                    subtitle: customText(
                                                      text:
                                                          'ID: ${employee.employeeId}',
                                                      id: 2,
                                                      textSize: 13,
                                                      color: AppColors.hint
                                                          .withOpacity(.5),
                                                    ),
                                                    trailing: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          width: 15,
                                                          color: AppColors.dark
                                                              .withOpacity(.07),
                                                          height: 1,
                                                        ),
                                                        CircleAvatar(
                                                          radius: 22,
                                                          backgroundColor:
                                                              AppColors.dark
                                                                  .withOpacity(
                                                                      .3),
                                                          child: CircleAvatar(
                                                              radius: 17,
                                                              backgroundColor:
                                                                  AppColors
                                                                      .white
                                                                      .withOpacity(
                                                                          .4),
                                                              child: Icon(
                                                                employee.personId !=
                                                                        null
                                                                    ? Iconsax
                                                                        .lock_1
                                                                    : Iconsax
                                                                        .lock_slash,
                                                                color: AppColors
                                                                    .dark,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                    // Add more widgets to display other employee details as needed.
                                                  ),
                                                ),
                                                Container(
                                                  height: 5,
                                                  width: size.width,
                                                  decoration: const BoxDecoration(
                                                      color: AppColors.dark,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                            : const Center(
                                child: CircularProgressIndicator(),
                              )),
                  ),
                ],
              )));
    });
  }

  deleteFaceIds(EmployeeProvider employee, Employees user,
      Rekognition rekognition, SharedPreferences pref, BuildContext context) {
    showGeneralDialog(
        context: context,
        barrierLabel: "",
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (filtercontext, __, ___) {
          return StatefulBuilder(builder: (context, setState) {
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
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customText(
                          id: 1,
                          text: "Delete faceId's of ${user.name}",
                          color: AppColors.primaryDarkColor,
                          weight: FontWeight.bold,
                          textSize: 22,
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: CircleAvatar(
                                backgroundColor: AppColors.white10,
                                child: const Icon(Iconsax.arrow_left_1,
                                    color: AppColors.dark))),
                      ],
                    ),
                    const Divider(),
                    Expanded(
                      flex: 0,
                      child: customText(
                        id: 1,
                        textSize: 16,
                        text:
                            "Are you sure to delete \nall faceId's of the user ${user.name}",
                      ),
                    ),
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
                                backgroundColor: Colors.red.shade900,
                                fixedSize: const Size(100, 50),
                              ),
                              onPressed: () async {
                                if (user.faceIds!.isNotEmpty) {
                                  await rekognition.deleteFaces(
                                      collectionId: StringConst.GROUP_ID,
                                      faceIds: user.faceIds!);
                                  employee.deletePersonId(
                                      personId: StringConst.GROUP_ID +
                                          user.id.toString(),
                                      usertype: widget.usertype);
                                } else {
                                  toast(
                                      context: context,
                                      txt: "No faces available for user",
                                      color: AppColors.black);
                                }
                                Navigator.pop(context);
                              },
                              child: const Row(children: [
                                Icon(Iconsax.trash, color: AppColors.white),
                                SizedBox(
                                  width: 10,
                                ),
                                customText(
                                  text: 'Delete',
                                  textSize: 19,
                                  id: 1,
                                  color: AppColors.white,
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
