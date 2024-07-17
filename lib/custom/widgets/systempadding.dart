import 'package:flutter/material.dart';

class SystemPadding extends StatelessWidget {
  final Widget child;

  const SystemPadding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
