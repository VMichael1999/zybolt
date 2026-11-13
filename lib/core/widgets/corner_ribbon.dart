import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_typography.dart';

/// Cinta diagonal de 170 × 28 anclada arriba a la derecha de la tarjeta.
/// Colócala dentro de un `Stack` recortado por la tarjeta.
class CornerRibbon extends StatelessWidget {
  const CornerRibbon({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 24,
      right: -44,
      width: 170,
      height: 28,
      child: Transform.rotate(
        angle: 38 * math.pi / 180,
        child: Container(
          alignment: Alignment.center,
          color: color,
          child: Text(
            label.toUpperCase(),
            style: AppTypography.of(
              11.5,
              FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.92,
            ),
          ),
        ),
      ),
    );
  }
}
