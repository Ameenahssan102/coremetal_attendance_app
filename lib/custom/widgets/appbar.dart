// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';

PreferredSizeWidget Appbar({Widget? leading,
  Widget? title,
  PreferredSizeWidget? bottom,
  Color? bgcolor,
  List<Widget>? actions,
  double? height}) {
  return AppBar(
    bottom: bottom,
    centerTitle: true,
    leading: leading,
    leadingWidth: 0,
    automaticallyImplyLeading: true,
    elevation: .5,
    title: title,
    backgroundColor: bgcolor,
    actions: actions,
    toolbarHeight: height,
  );
}
