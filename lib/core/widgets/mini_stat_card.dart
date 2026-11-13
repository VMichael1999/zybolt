import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'stat_cards.dart';

class MiniStatCard extends StatelessWidget {
  const MiniStatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    this.peach = false,
  });

  final String icon;
  final Color iconColor;
  final String value;
  final String label;
  final bool peach;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: peach ? AppColors.peach : AppColors.card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconSquare(icon: icon, color: iconColor),
          const SizedBox(height: 10),
          Text(value, style: AppTypography.of(18, FontWeight.w800)),
          Text(
            label,
            style: AppTypography.of(
              12,
              FontWeight.w500,
              color: AppColors.metaGrey,
            ),
          ),
        ],
      ),
    );
  }
}
