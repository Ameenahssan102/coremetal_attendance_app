import 'package:face_app/utils/detected_image.dart';
import 'package:face_app/utils/enums.dart';
import 'package:flutter/material.dart';

/// Returns widget for flash modes
typedef FlashControlBuilder = Widget Function(
    BuildContext context, CameraFlashMode mode);

/// Returns message based on face position
typedef MessageBuilder = Widget Function(
    BuildContext context, DetectedFace? detectedFace);

/// Returns widget for detector
typedef IndicatorBuilder = Widget Function(
    BuildContext context, DetectedFace? detectedFace, Size? imageSize);

/// Returns widget for capture control
typedef CaptureControlBuilder = Widget Function(
    BuildContext context, DetectedFace? detectedFace);
