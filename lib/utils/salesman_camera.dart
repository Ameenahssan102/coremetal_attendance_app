import 'dart:io';

import 'package:face_app/Values/values.dart';
import 'package:face_app/custom/widgets/custom_text.dart';
import 'package:face_app/utils/builders.dart';
import 'package:face_app/utils/detected_image.dart';
import 'package:face_app/utils/enum_handler.dart';
import 'package:face_app/utils/enums.dart';
import 'package:face_app/utils/face_camera.dart';
import 'package:face_app/utils/face_identifier.dart';
import 'package:face_app/utils/face_painter.dart';
import 'package:face_app/utils/hole_painter.dart';
import 'package:face_app/utils/logger.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:iconsax/iconsax.dart';

class SalesmanCamera extends StatefulWidget {
  final ImageResolution imageResolution;
  final CameraLens? defaultCameraLens;
  final CameraFlashMode defaultFlashMode;
  final bool enableAudio;
  final bool autoCapture;
  final bool showControls;
  final bool showCaptureControl;
  final bool showFlashControl;
  final bool showCameraLensControl;
  final String? message;
  final void Function(File? image) onCheckin;
  final void Function(File? image) onCheckout;
  final TextStyle messageStyle;
  final CameraOrientation? orientation;
  final void Function(Face? face)? onFaceDetected;
  final Widget? captureControlIcon;
  final Widget? lensControlIcon;
  final FlashControlBuilder? flashControlBuilder;
  final MessageBuilder? messageBuilder;
  final IndicatorShape indicatorShape;
  final String? indicatorAssetImage;
  final IndicatorBuilder? indicatorBuilder;

  const SalesmanCamera(
      {this.imageResolution = ImageResolution.medium,
      this.defaultCameraLens,
      this.enableAudio = true,
      this.autoCapture = false,
      this.showControls = true,
      this.showCaptureControl = true,
      this.showFlashControl = true,
      this.showCameraLensControl = true,
      this.message,
      this.defaultFlashMode = CameraFlashMode.auto,
      this.orientation = CameraOrientation.portraitUp,
      this.messageStyle = const TextStyle(
          fontSize: 14, height: 1.5, fontWeight: FontWeight.w400),
      this.onFaceDetected,
      this.captureControlIcon,
      this.lensControlIcon,
      this.flashControlBuilder,
      this.messageBuilder,
      this.indicatorShape = IndicatorShape.defaultShape,
      this.indicatorAssetImage,
      this.indicatorBuilder,
      super.key,
      required this.onCheckin,
      required this.onCheckout})
      : assert(
            indicatorShape != IndicatorShape.image ||
                indicatorAssetImage != null,
            'IndicatorAssetImage must be provided when IndicatorShape is set to image.');

  @override
  State<SalesmanCamera> createState() => _SalesmanCameraState();
}

class _SalesmanCameraState extends State<SalesmanCamera>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? _controller;

  bool _alreadyCheckingImage = false;

  DetectedFace? _detectedFace;

  int _currentCameraLens = 0;
  final List<CameraLens> _availableCameraLens = [];

  void _getAllAvailableCameraLens() {
    for (CameraDescription d in FaceCamera.cameras) {
      final lens = EnumHandler.cameraLensDirectionToCameraLens(d.lensDirection);
      if (lens != null && !_availableCameraLens.contains(lens)) {
        _availableCameraLens.add(lens);
      }
    }

    if (widget.defaultCameraLens != null) {
      try {
        _currentCameraLens =
            _availableCameraLens.indexOf(widget.defaultCameraLens!);
      } catch (e) {
        logError(e.toString());
      }
    }
  }

  Future<void> _initCamera() async {
    final cameras = FaceCamera.cameras
        .where((c) =>
            c.lensDirection ==
            EnumHandler.cameraLensToCameraLensDirection(
                _availableCameraLens[_currentCameraLens]))
        .toList();

    if (cameras.isNotEmpty) {
      _controller = CameraController(cameras.first,
          EnumHandler.imageResolutionToResolutionPreset(widget.imageResolution),
          enableAudio: false,
          imageFormatGroup: Platform.isAndroid
              ? ImageFormatGroup.nv21
              : ImageFormatGroup.bgra8888);
      await _controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
      await _controller!
          .lockCaptureOrientation(
              EnumHandler.cameraOrientationToDeviceOrientation(
                  widget.orientation))
          .then((_) {
        if (mounted) setState(() {});
      });
    }
    _startImageStream();
  }

  // void stopCameraStream() {
  //   if (_controller != null && _controller!.value.isStreamingImages) {
  //     _controller!.stopImageStream();
  //   }
  // }
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _getAllAvailableCameraLens();
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final CameraController? cameraController = _controller;
    if (cameraController != null && cameraController.value.isInitialized) {
      // stopCameraStream();
      cameraController.dispose();
    }

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.stopImageStream();
    } else if (state == AppLifecycleState.resumed) {
      _startImageStream();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final CameraController? cameraController = _controller;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (cameraController != null &&
            cameraController.value.isInitialized) ...[
          Transform.scale(
            scale: 1.1,
            child: AspectRatio(
              aspectRatio: size.aspectRatio,
              child: OverflowBox(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: SizedBox(
                    width: size.width,
                    height: size.width * cameraController.value.aspectRatio,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        _cameraDisplayWidget(),
                        if (_detectedFace != null) ...[
                          SizedBox(
                              width: cameraController.value.previewSize!.width,
                              height:
                                  cameraController.value.previewSize!.height,
                              child: widget.indicatorBuilder?.call(
                                      context,
                                      _detectedFace,
                                      Size(
                                        _controller!.value.previewSize!.height,
                                        _controller!.value.previewSize!.width,
                                      )) ??
                                  CustomPaint(
                                    painter: FacePainter(
                                        face: _detectedFace!.face,
                                        indicatorShape: widget.indicatorShape,
                                        indicatorAssetImage:
                                            widget.indicatorAssetImage,
                                        imageSize: Size(
                                          _controller!
                                              .value.previewSize!.height,
                                          _controller!.value.previewSize!.width,
                                        )),
                                  ))
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ] else ...[
          const Align(
            alignment: Alignment.center,
            child: Text('No Camera Detected',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                )),
          ),
          CustomPaint(
            size: size,
            painter: HolePainter(),
          )
        ],
        if (widget.showControls) ...[
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: _captureControlWidget(
                  size, widget.onCheckin, widget.onCheckout),
            ),
          )
        ]
      ],
    );
  }

  /// Render camera.
  Widget _cameraDisplayWidget() {
    final CameraController? cameraController = _controller;
    if (cameraController != null && cameraController.value.isInitialized) {
      return CameraPreview(cameraController, child: Builder(builder: (context) {
        if (widget.messageBuilder != null) {
          return widget.messageBuilder!.call(context, _detectedFace);
        }
        if (widget.message != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 55),
            child: Text(widget.message!,
                textAlign: TextAlign.center, style: widget.messageStyle),
          );
        }
        return const SizedBox.shrink();
      }));
    }
    return const SizedBox.shrink();
  }

  /// Display the control buttons to take pictures.
  Widget _captureControlWidget(Size size, void Function(File? image)? onCheckin,
      void Function(File? image)? onCheckout) {
    final CameraController? cameraController = _controller;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      TextButton(
          clipBehavior: Clip.antiAlias,
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(10),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
            backgroundColor: MaterialStateProperty.all(
                AppColors.primaryDarkColor.withOpacity(.5)),
            fixedSize: MaterialStateProperty.all(Size(size.width * 0.40, 60)),
          ),
          onPressed:
              cameraController != null && cameraController.value.isInitialized
                  ? _onTakePictureButtonPressed
                  : null,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Iconsax.arrow_up_14, color: AppColors.white10),
            const SizedBox(
              width: 10,
            ),
            const customText(
              text: 'Check In',
              id: 1,
              textSize: 20,
              color: AppColors.white,
            ),
          ])),
      TextButton(
          clipBehavior: Clip.antiAlias,
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(10),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
            backgroundColor: MaterialStateProperty.all(
                AppColors.primaryDarkColor.withOpacity(.5)),
            fixedSize: MaterialStateProperty.all(Size(size.width * 0.40, 60)),
          ),
          onPressed:
              cameraController != null && cameraController.value.isInitialized
                  ? _onTakePictureButtonPressed2
                  : null,
          child: const Row(children: [
            Icon(Iconsax.arrow_down_24, color: AppColors.white),
            SizedBox(
              width: 10,
            ),
            customText(
              text: 'Check Out',
              id: 1,
              textSize: 20,
              color: Colors.white,
            ),
          ])),
    ]);

    // IconButton(
    //   iconSize: 70,
    //   icon: widget.captureControlIcon ??
    //       const CircleAvatar(
    //           radius: 70,
    //           child: Padding(
    //             padding: EdgeInsets.all(8.0),
    //             child: Icon(Icons.camera_alt, size: 35),
    //           )),
    //   onPressed:
    // cameraController != null && cameraController.value.isInitialized
    //     ? _onTakePictureButtonPressed
    //     : null,
    // );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(SnackBar(content: Text("Error")));
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (_controller == null) {
      return;
    }

    final CameraController cameraController = _controller!;

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  void _onTakePictureButtonPressed() async {
    final CameraController? cameraController = _controller;
    try {
      cameraController!.stopImageStream().whenComplete(() async {
        await Future.delayed(const Duration(milliseconds: 0));
        takePicture().then((XFile? file) {
          /// Return image callback
          if (file != null) {
            widget.onCheckin(File(file.path));
          }
          Future.delayed(const Duration(milliseconds: 5)).whenComplete(() {
            if (mounted && cameraController.value.isInitialized) {
              try {
                _startImageStream();
              } catch (e) {
                logError(e.toString());
              }
            }
          });
        });
      });
    } catch (e) {
      logError(e.toString());
    }
  }

  void _onTakePictureButtonPressed2() async {
    final CameraController? cameraController = _controller;
    try {
      cameraController!.stopImageStream().whenComplete(() async {
        await Future.delayed(const Duration(milliseconds: 0));
        takePicture().then((XFile? file) {
          /// Return image callback
          if (file != null) {
            widget.onCheckout(File(file.path));
          }
          Future.delayed(const Duration(milliseconds: 5)).whenComplete(() {
            if (mounted && cameraController.value.isInitialized) {
              try {
                _startImageStream();
              } catch (e) {
                logError(e.toString());
              }
            }
          });
        });
      });
    } catch (e) {
      logError(e.toString());
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      logError('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      logError(e.description.toString());
      return null;
    }
  }

  void _startImageStream() {
    final CameraController? cameraController = _controller;
    if (cameraController != null) {
      cameraController.startImageStream(_processImage);
    }
  }

  void _processImage(CameraImage cameraImage) async {
    final CameraController? cameraController = _controller;
    if (!_alreadyCheckingImage && mounted) {
      _alreadyCheckingImage = true;
      try {
        await FaceIdentifier.scanImage(
                cameraImage: cameraImage, controller: cameraController)
            .then((result) async {
          setState(() => _detectedFace = result);

          if (result != null) {
            try {
              if (result.wellPositioned) {
                if (widget.onFaceDetected != null) {
                  widget.onFaceDetected!.call(result.face);
                }
                if (widget.autoCapture) {
                  _onTakePictureButtonPressed();
                }
              }
            } catch (e) {
              logError(e.toString());
            }
          }
        });
        _alreadyCheckingImage = false;
      } catch (ex, stack) {
        logError('$ex, $stack');
      }
    }
  }
}
