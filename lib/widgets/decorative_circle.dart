import 'package:flutter/material.dart';

/// Lingkaran dekoratif reusable, dipakai di header & welcome card.
class DecorativeCircle extends StatelessWidget {
  final double size;
  final Color color;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const DecorativeCircle({
    super.key,
    required this.size,
    required this.color,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
