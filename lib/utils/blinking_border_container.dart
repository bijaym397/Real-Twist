import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class BlinkingBorderContainer extends StatefulWidget {

  final Widget child;

  const BlinkingBorderContainer({super.key, required this.child});

  @override
  _BlinkingBorderContainerState createState() => _BlinkingBorderContainerState();
}

class _BlinkingBorderContainerState extends State<BlinkingBorderContainer> {
  bool isDottedVisible = true;

  @override
  void initState() {
    super.initState();
    // Set up a timer to toggle the visibility of the dots
    Timer.periodic(const Duration(milliseconds: 500), (Timer t) {
      setState(() {
        isDottedVisible = !isDottedVisible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = isDottedVisible ? Colors.yellow : Colors.red;

    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.all(10),
      child: DottedBorder(
        color: borderColor,
        strokeWidth: 5,
        dashPattern: isDottedVisible ? const [8, 4] : const [10, 6],
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(16),
          child: widget.child,
        ),
      ),
    );
  }
}
