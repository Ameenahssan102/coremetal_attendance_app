// // ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

// import 'package:ncp/Values/values.dart';
// import 'package:ncp/custom/widgets/custom_text.dart';
// import 'package:ncp/custom/widgets/custom_textfield.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';

// FormPop(
//   BuildContext context,
//   TextEditingController? controller1,
//   TextEditingController? controller2,
//   bool? checkedValue,
//   bool? checkedValue2,
//   void Function(bool?) onchanged,
//   void Function(bool?) onchanged2,
// ) {
//   final _formKey = GlobalKey<FormState>();

//   return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(builder: (context, setState) {
//           return AlertDialog(
//               title: Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: 50,
//                   child: Column(
//                     children: [
//                       customText(
//                         text: "Add an Individual",
//                         id: 2,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                         child: Divider(
//                           color: AppColors.primaryColor,
//                           thickness: 0.2,
//                         ),
//                       ),
//                     ],
//                   )),
//               content: Container(
//                 child: Stack(children: <Widget>[
//                   Form(
//                     child: Container(
//                       width: MediaQuery.of(context).size.width,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           CustomTextFormField(
//                             controller: controller1,
//                             lbltxt: "Name",
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           CustomTextFormField(
//                             controller: controller2,
//                             lbltxt: "type",
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           CheckboxListTile(
//                             title: Text("Extras 1"),
//                             value: checkedValue,
//                             onChanged: onchanged,
//                             controlAffinity: ListTileControlAffinity
//                                 .leading, //  <-- leading Checkbox
//                           ),
//                           CheckboxListTile(
//                             title: Text("Extras 2"),
//                             value: checkedValue2,
//                             onChanged: onchanged2,
//                             controlAffinity: ListTileControlAffinity
//                                 .leading, //  <-- leading Checkbox
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           MaterialButton(
//                               minWidth: MediaQuery.of(context).size.width,
//                               height: 50,
//                               color: AppColors.primaryDarkColor,
//                               child: customText(
//                                 text: "Submit",
//                                 id: 1,
//                                 color: AppColors.white,
//                               ),
//                               onPressed: () {
//                                 if (_formKey.currentState!.validate()) {
//                                   _formKey.currentState!.save();
//                                 }
//                               }),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ]),
//               ));
//         });
//       });
// }
