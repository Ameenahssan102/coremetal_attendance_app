// ignore_for_file: prefer_const_constructors

import 'package:face_app/Values/values.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileTile extends StatelessWidget {
  final void Function() navigateto;
  final IconData? icon;
  final String tiletext;
  final Color? color;

  const ProfileTile(
      {super.key,
      required this.navigateto,
      this.icon,
      required this.tiletext,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.white,
          height: 1.0,
        ),
        Material(
          color: AppColors.white,
          child: InkWell(
            onTap: navigateto,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // boxShadow: [
                //   BoxShadow(
                //       offset: Offset(0, 0),
                //       blurRadius: 10,
                //       color: Colors.indigo.shade50)
                // ]
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.all(8.0),
              height: 56.0,
              child: Row(
                children: [
                  SizedBox(
                    width: 8.0,
                  ),
                  Icon(
                    icon,
                    color: AppColors.primaryColor,
                    size: 20.0,
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Expanded(
                    child: Text(
                      tiletext,
                      style: GoogleFonts.poppins(
                          color: color, fontSize: Sizes.TEXT_SIZE_18),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16.0,
                    color: AppColors.hint.withOpacity(0.2),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
