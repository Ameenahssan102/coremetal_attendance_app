import 'package:flutter/material.dart';

class Elevatedbutton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;
  final Color? bgcolor;
  final double? elevation;
  final EdgeInsets? padding;
  final Size? fixedsize;

  const Elevatedbutton(
      {super.key,
      required this.onPressed,
      required this.child,
      this.bgcolor,
      this.elevation,
      this.padding,
      this.fixedsize});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(bgcolor),
          elevation: MaterialStateProperty.all(elevation),
          padding: MaterialStateProperty.all(padding),
          fixedSize: MaterialStateProperty.all(fixedsize)),
      child: child,
    );
  }
}
