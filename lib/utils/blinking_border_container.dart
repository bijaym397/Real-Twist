import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class BlinkingBorderContainer extends StatefulWidget {

  final Widget child;
  final String backgroundImage;

  const BlinkingBorderContainer({super.key, required this.child, required this.backgroundImage});

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
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(widget.backgroundImage),
          fit: BoxFit.cover,
          opacity: 0.2
        ),
        color: Colors.black87,
      ),
      padding: const EdgeInsets.all(10),
      child: DottedBorder(
        color: borderColor,
        strokeWidth: 6,
        dashPattern: isDottedVisible ? const [1, 25] : const [1, 30],
        strokeCap:StrokeCap.round,
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
