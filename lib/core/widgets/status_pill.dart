import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum StatusPillVariant { inTransitDark, inTransit, delivered }

class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    this.variant = StatusPillVariant.inTransitDark,
    this.height,
  });

  final String label;
  final StatusPillVariant variant;
  final double? height;

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case StatusPillVariant.inTransitDark:
        return Container(
          height: height ?? 22,
          padding: const EdgeInsets.symmetric(horizontal: 9),
          decoration: BoxDecoration(
            color: AppColors.pillDark,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 6,
                height: 6,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: AppTypography.of(
                  11.5,
                  FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        );
      case StatusPillVariant.inTransit:
      case StatusPillVariant.delivered:
        final transit = variant == StatusPillVariant.inTransit;
        return Container(
          height: height ?? 24,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: transit ? AppColors.transitBg : AppColors.greenSoft,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: AppTypography.of(
              11.5,
              FontWeight.w700,
              color: transit ? AppColors.transitFg : AppColors.green,
            ),
          ),
        );
    }
  }
}
