import 'package:face_app/providers/auth_provider.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Values/values.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AfterLayoutMixin {
  @override
  void afterFirstLayout(BuildContext context) {
    LoginProvider authProvider =
        Provider.of<LoginProvider>(context, listen: false);
    authProvider.goto();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: AppColors.white,
      child: Stack(
        children: [
          Center(
              child: Image.asset(
            "assets/images/logo.jpg",
            width: size.width / 1.5,
          )),
          const Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
                child: CircularProgressIndicator(
              color: AppColors.primaryDarkColor,
              strokeWidth: 3.0,
            )),
          )
        ],
      ),
    );
  }
}
