import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'app_icon.dart';
import 'status_pill.dart';

class QuickActionButton extends StatelessWidget {
  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.primary = false,
    this.onTap,
  });

  final String icon;
  final String label;
  final bool primary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: primary ? AppColors.dark : AppColors.white,
              shape: BoxShape.circle,
            ),
            child: AppIcon(
              icon,
              size: 22,
              color: primary ? AppColors.white : AppColors.ink,
            ),
          ),
          const SizedBox(height: 7),
          Text(label, style: AppTypography.of(12.5, FontWeight.w600)),
        ],
      ),
    );
  }
}

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.title,
    required this.amount,
    required this.hidden,
    required this.meta,
    required this.todayLabel,
    required this.actions,
    required this.onToggleVisibility,
    required this.showLabel,
    required this.hideLabel,
  });

  final String title;
  final String amount;
  final bool hidden;
  final String meta;
  final String todayLabel;
  final List<QuickActionButton> actions;
  final VoidCallback onToggleVisibility;
  final String showLabel;
  final String hideLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.headerOrange,
        borderRadius: BorderRadius.circular(26),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -50,
            top: -60,
            child: Container(
              width: 190,
              height: 190,
              decoration: const BoxDecoration(
                color: AppColors.circleDecoration,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.of(
                    13.5,
                    FontWeight.w500,
                    color: AppColors.balanceSub,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      amount,
                      style: AppTypography.of(
                        34,
                        FontWeight.w800,
                        letterSpacing: -0.34,
                      ),
                    ),
                    Semantics(
                      button: true,
                      label: hidden ? showLabel : hideLabel,
                      excludeSemantics: true,
                      child: GestureDetector(
                        onTap: onToggleVisibility,
                        child: Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: AppColors.eyeButton,
                            shape: BoxShape.circle,
                          ),
                          child: AppIcon(hidden ? 'eye-off' : 'eye'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      meta,
                      style: AppTypography.of(
                        12.5,
                        FontWeight.w500,
                        color: AppColors.headerSub,
                      ),
                    ),
                    StatusPill(label: todayLabel, height: 24),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    for (var i = 0; i < actions.length; i++) ...[
                      if (i > 0) const SizedBox(width: 10),
                      Expanded(child: Center(child: actions[i])),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
