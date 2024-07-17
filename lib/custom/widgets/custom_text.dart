// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class customText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? ltrspacing;
  final double? textSize;
  final FontWeight? weight;
  final TextAlign? align;
  final TextDecoration? decoration;
  final int id;

  const customText({
    super.key,
    required this.text,
    this.color,
    this.ltrspacing,
    this.textSize,
    this.weight,
    this.align,
    required this.id,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: id == 1
          ? GoogleFonts.lato(
              color: color,
              letterSpacing: ltrspacing,
              fontSize: textSize,
              fontWeight: weight,
            )
          : GoogleFonts.cabinCondensed(
              color: color,
              letterSpacing: ltrspacing,
              fontSize: textSize,
              fontWeight: weight,
              decoration: decoration),
      overflow: TextOverflow.clip,
      textAlign: align,
    );
  }
}
