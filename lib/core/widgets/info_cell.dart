import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class InfoCell extends StatelessWidget {
  const InfoCell({
    super.key,
    required this.label,
    required this.value,
    this.sub,
    this.caps = false,
  });

  final String label;
  final String value;
  final String? sub;

  /// Estilo «DE / PARA» de las tarjetas de envío (11/600 con espaciado).
  final bool caps;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              caps
                  ? AppTypography.of(
                    11,
                    FontWeight.w600,
                    color: AppColors.timelineHint,
                    letterSpacing: 0.33,
                  )
                  : AppTypography.of(
                    12.5,
                    FontWeight.w500,
                    color: AppColors.timelineHint,
                  ),
        ),
        const SizedBox(height: 3),
        Text(value, style: AppTypography.of(15, FontWeight.w700)),
        if (sub != null) ...[
          const SizedBox(height: 1),
          Text(
            sub!,
            style: AppTypography.of(
              12,
              FontWeight.w500,
              color: AppColors.metaGrey,
            ),
          ),
        ],
      ],
    );
  }
}

/// Cuadrícula de dos columnas (1fr / 1.2fr) al 70 % del ancho.
class InfoGrid extends StatelessWidget {
  const InfoGrid({super.key, required this.rows, this.rowGap = 4});

  final List<List<Widget>> rows;
  final double rowGap;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.7,
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) SizedBox(height: rowGap),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 100, child: rows[i][0]),
                const SizedBox(width: 14),
                Expanded(flex: 120, child: rows[i][1]),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
