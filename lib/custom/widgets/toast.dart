import 'package:face_app/Values/values.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

toast(
    {required BuildContext context,
    required String txt,
    required Color color}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    elevation: 2,
    padding: const EdgeInsets.all(6.0),
    dismissDirection: DismissDirection.horizontal,
    backgroundColor: AppColors.white10,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          txt,
          style: GoogleFonts.lato(color: color, fontSize: 16.0),
        ),
      ],
    ),
  ));
}
