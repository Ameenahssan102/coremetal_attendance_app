// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_typing_uninitialized_variables, use_key_in_widget_constructors

import 'package:face_app/Values/values.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final hintText;
  final lbltxt;
  final textcolor;
  final onSaved;
  final suffixIcon;
  final font;
  final hintColor;
  final fillcolor;
  final flotstyle;
  final TextInputType? type;
  final int id;
  final int? maxlines;
  final bool? obscureText;

  final FloatingLabelBehavior? floatbehavior;

  final labelColor;
  final FormFieldValidator? validator;
  final onchanged;

  const CustomTextFormField({
    this.hint,
    this.controller,
    this.focusNode,
    this.hintText,
    this.lbltxt,
    this.textcolor,
    this.font,
    this.hintColor,
    this.floatbehavior,
    this.labelColor,
    this.validator,
    this.onSaved,
    this.suffixIcon,
    this.fillcolor,
    this.flotstyle,
    this.onchanged,
    this.type,
    required this.id,
    this.maxlines,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        obscureText: obscureText == null ? false : true,
        cursorColor: AppColors.primaryColor,
        keyboardType: type,
        readOnly: id == 1 ? true : false,
        onChanged: onchanged,
        onSaved: onSaved,
        focusNode: focusNode,
        validator: validator,
        maxLines: maxlines,
        style: GoogleFonts.lato(color: textcolor, fontSize: Sizes.TEXT_SIZE_18),
        controller: controller,
        decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
            fillColor: fillcolor,
            floatingLabelStyle: flotstyle,
            // hintStyle: GoogleFonts.arya(color: hintColor, fontSize: 12),
            floatingLabelBehavior: floatbehavior,
            labelText: lbltxt,
            labelStyle: TextStyle(color: labelColor),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            )));
  }
}
