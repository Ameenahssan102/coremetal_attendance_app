// ignore_for_file: use_build_context_synchronously

import 'package:face_app/Values/values.dart';
import 'package:face_app/providers/auth_provider.dart';
import 'package:face_app/providers/employee_provider.dart';
import 'package:face_app/splash_screen.dart';
import 'package:face_app/utils/face_camera.dart';
import 'package:face_app/utils/navigation_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'locator.dart' as ltr;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FaceCamera.initialize();
  await ltr.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ltr.loc<LoginProvider>()),
        ChangeNotifierProvider(
            create: (context) => ltr.loc<EmployeeProvider>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    fetchPosition(context);
  }

  Future<void> fetchPosition(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(msg: 'Location permission is required.');
      }
    }

    if (!serviceEnabled) {
      bool locationSettingsOpened = await Geolocator.openLocationSettings();
      if (!locationSettingsOpened) {
        Fluttertoast.showToast(msg: 'Failed to open location settings.');
      }
    }
    // Get the current position.
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Update the position provider.
    final positionProvider =
        Provider.of<EmployeeProvider>(context, listen: false);
    if (kDebugMode) {
      print(currentPosition.latitude);
    }
    positionProvider.currentPosition = currentPosition;
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        color: AppColors.primaryDarkColor,
        navigatorKey: NavigationService.navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Coremetal Faceapp',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const SplashScreen(),
      ),
    );
  }
}
