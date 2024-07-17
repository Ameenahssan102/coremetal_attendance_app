// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, file_names

import 'package:face_app/Values/values.dart';
import 'package:face_app/custom/widgets/custom_text.dart';
import 'package:face_app/custom/widgets/custom_textfield.dart';
import 'package:face_app/custom/widgets/systempadding.dart';
import 'package:flutter/material.dart';

class ErrorDialog {
  static showErrorDialog(
      {required BuildContext context,
      required TextEditingController idcontroller2,
      required TextEditingController namecontroller,
      required TextEditingController typecontroller,
      required String errormessage,
      required Function() logOnpressed,
      required Function() okOnpressed,
      required Widget userdetailcount}) {
    showGeneralDialog(
        context: context,
        barrierLabel: "Add by id",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 300),
        pageBuilder: (filtercontext, __, ___) {
          return StatefulBuilder(builder: (context, setState) {
            return SystemPadding(
              child: Center(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        userdetailcount,
                        SizedBox(
                          height: 10,
                        ),
                        Material(
                            color: AppColors.white,
                            child: CustomTextFormField(
                              id: 1,
                              labelColor: AppColors.primaryDarkColor,
                              lbltxt: "ID",
                              controller: idcontroller2,
                              type: TextInputType.number,
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Material(
                            color: AppColors.white,
                            child: CustomTextFormField(
                              id: 1,
                              labelColor: AppColors.primaryDarkColor,
                              lbltxt: "Name",
                              controller: namecontroller,
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Material(
                            color: AppColors.white,
                            child: CustomTextFormField(
                              id: 1,
                              labelColor: AppColors.primaryDarkColor,
                              lbltxt: "Type",
                              controller: typecontroller,
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Material(
                          color: AppColors.white,
                          child: customText(
                              text: errormessage,
                              color: AppColors.red.withOpacity(0.7),
                              textSize: Sizes.TEXT_SIZE_16,
                              id: 2),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Divider(
                            color: AppColors.primaryColor,
                            thickness: 0.2,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 30,
                          child: MaterialButton(
                            elevation: 0,
                            onPressed: logOnpressed,
                            color: AppColors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.history,
                                      color: AppColors.primaryColor
                                          .withOpacity(0.8)),
                                  SizedBox(
                                    width: 7.0,
                                  ),
                                  customText(
                                      text: "Collection Logs",
                                      id: 2,
                                      color: AppColors.hint.withOpacity(0.5)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 1.0),
                                child: Container(
                                  height: 55.0,
                                  width:
                                      MediaQuery.of(context).size.width * 0.80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: MaterialButton(
                                    onPressed: okOnpressed,
                                    color:
                                        AppColors.primaryColor.withOpacity(0.8),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.check_circle_outline_outlined,
                                            color: AppColors.white,
                                          ),
                                          SizedBox(
                                            width: 7.0,
                                          ),
                                          customText(
                                              text: "Ok",
                                              id: 1,
                                              color: Colors.white),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ]))),
            );
          });
        });
  }
}
