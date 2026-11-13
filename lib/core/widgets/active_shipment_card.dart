import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'app_icon.dart';
import 'flag_pair.dart';
import 'status_pill.dart';

class ActiveShipmentCard extends StatelessWidget {
  const ActiveShipmentCard({
    super.key,
    required this.flagA,
    required this.flagB,
    required this.statusLabel,
    required this.delivered,
    required this.from,
    required this.to,
    required this.order,
    this.onTap,
  });

  final String flagA;
  final String flagB;
  final String statusLabel;
  final bool delivered;
  final String from;
  final String to;
  final String order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 178,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlagPair(first: flagA, second: flagB),
                StatusPill(
                  label: statusLabel,
                  variant:
                      delivered
                          ? StatusPillVariant.delivered
                          : StatusPillVariant.inTransit,
                ),
              ],
            ),
            const SizedBox(height: 14),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(from, style: AppTypography.of(14, FontWeight.w700)),
                  const SizedBox(width: 6),
                  const AppIcon('arrow-r', size: 13, strokeWidth: 2.4),
                  const SizedBox(width: 6),
                  Text(to, style: AppTypography.of(14, FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              order,
              style: AppTypography.of(
                12,
                FontWeight.w500,
                color: AppColors.metaGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
