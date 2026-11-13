import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_durations.dart';
import '../theme/app_typography.dart';

enum BannerVariant { packed, transit, delivered }

class DeliveryStatusBanner extends StatelessWidget {
  const DeliveryStatusBanner({
    super.key,
    required this.variant,
    required this.text,
    required this.data,
  });

  final BannerVariant variant;
  final String text;
  final String data;

  (Color, Color, Color) get _colors {
    switch (variant) {
      case BannerVariant.packed:
        return (AppColors.packedBg, AppColors.packedFg, AppColors.packedData);
      case BannerVariant.transit:
        return (
          AppColors.transitBannerBg,
          AppColors.transitBannerFg,
          AppColors.transitBannerFg,
        );
      case BannerVariant.delivered:
        return (AppColors.greenSoft, AppColors.green, AppColors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (bg, fg, dataColor) = _colors;
    return AnimatedContainer(
      duration: AppDurations.banner,
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: fg,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(color: AppColors.dotHalo, spreadRadius: 3),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: AnimatedDefaultTextStyle(
              duration: AppDurations.banner,
              style: AppTypography.of(14, FontWeight.w600, color: fg),
              child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ),
          AnimatedDefaultTextStyle(
            duration: AppDurations.banner,
            style: AppTypography.of(13, FontWeight.w600, color: dataColor),
            child: Text(data),
          ),
        ],
      ),
    );
  }
}
