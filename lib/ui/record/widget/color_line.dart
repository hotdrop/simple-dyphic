import 'package:flutter/material.dart';

class VerticalColorLine extends StatelessWidget {
  const VerticalColorLine({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.0,
      width: 2,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(4.0),
        ),
      ),
    );
  }
}
