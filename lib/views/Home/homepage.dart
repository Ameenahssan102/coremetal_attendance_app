// import 'package:face_app/Values/values.dart';
// import 'package:face_app/custom/widgets/custom_text.dart';
// import 'package:face_app/views/Employees/employees.dart';
// import 'package:face_app/views/Profile/profile.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';

// class Homepage extends StatefulWidget {
//   final bool usertype;

//   const Homepage({super.key, required this.usertype});

//   @override
//   State<Homepage> createState() => _HomepageState();
// }

// class _HomepageState extends State<Homepage> {
//   // final _pages = [const Tab1(usertype: false), const Tab2()];

//   // final awsClient = AWSClient();

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return SafeArea(
//         child: DefaultTabController(
//             length: 2,
//             child: Scaffold(
//               appBar: AppBar(
//                 backgroundColor: AppColors.primaryDarkColor,
//                 leadingWidth: 150,
//                 toolbarHeight: 80,
//                 actions: [
//                   InkWell(
//                       splashColor: Colors.transparent,
//                       focusColor: Colors.transparent,
//                       hoverColor: Colors.transparent,
//                       highlightColor: Colors.transparent,
//                       onTap: () async {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => EmployeeListView(
//                                       usertype: widget.usertype,
//                                     )));
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           children: [
//                             CircleAvatar(
//                               radius: 28,
//                               backgroundColor:
//                                   AppColors.white10.withOpacity(.3),
//                               child: CircleAvatar(
//                                   backgroundColor:
//                                       AppColors.white.withOpacity(.4),
//                                   child: const Icon(
//                                     Iconsax.activity,
//                                     color: AppColors.white,
//                                   )),
//                             ),
//                             // const SizedBox(
//                             //   width: 10,
//                             // )
//                           ],
//                         ),
//                       )),
//                   // const SizedBox(
//                   //   width: 10,
//                   // ),
//                   InkWell(
//                       splashColor: Colors.transparent,
//                       focusColor: Colors.transparent,
//                       hoverColor: Colors.transparent,
//                       highlightColor: Colors.transparent,
//                       onTap: () async {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const ProfileWidget()));
//                       },
//                       child: Row(
//                         children: [
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           CircleAvatar(
//                             radius: 28,
//                             backgroundColor: AppColors.white10.withOpacity(.3),
//                             child: CircleAvatar(
//                                 backgroundColor:
//                                     AppColors.white.withOpacity(.4),
//                                 child: const Icon(
//                                   Iconsax.setting_2,
//                                   color: AppColors.white,
//                                 )),
//                           ),
//                         ],
//                       )),
//                   const SizedBox(
//                     width: 10,
//                   ),
//                 ],
//                 leading: const Row(
//                   children: [
//                     SizedBox(
//                       width: 20,
//                     ),
//                     customText(
//                       text: "COREMETAL",
//                       id: 0,
//                       textSize: 23,
//                     ),
//                   ],
//                 ),
//                 bottom: widget.usertype == true
//                     ? PreferredSize(
//                         preferredSize: Size(size.width, 50),
//                         child: AppBar(
//                           centerTitle: true,
//                           toolbarHeight: 45,
//                           backgroundColor: AppColors.blue,
//                           elevation: 0,
//                           title: const customText(
//                             text: "Attendance",
//                             id: 1,
//                             color: AppColors.primaryDarkColor,
//                           ),
//                         ))
//                     : TabBar(
//                         labelColor: AppColors.blue,
//                         dividerColor: AppColors.white,
//                         indicatorColor: AppColors.blue,
//                         indicatorWeight: 6,
//                         unselectedLabelColor: AppColors.white10.withOpacity(.3),
//                         tabs: [
//                           const Tab(text: 'Attendance'),
//                           const Tab(text: 'Meeting'),
//                         ],
//                       ),
//               ),
//               body: widget.usertype == true
//                   ? const Tab1(
//                       usertype: true,
//                     )
//                   : TabBarView(children: _pages),
//             )));
//   }
// }
