import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'app_icon.dart';

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({
    super.key,
    required this.number,
    required this.detail,
    this.dark = false,
    this.badge,
    this.gradient,
  });

  final String number;
  final String detail;
  final bool dark;
  final String? badge;
  final Gradient? gradient;

  static const Gradient defaultChip = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.cardChipA, AppColors.cardChipB],
  );

  static const Gradient orangeChip = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.headerOrange, AppColors.primary],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? AppColors.dark : AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 24,
                decoration: BoxDecoration(
                  gradient: gradient ?? defaultChip,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 26),
              Text(
                number,
                style: AppTypography.of(
                  15,
                  FontWeight.w700,
                  color: dark ? AppColors.white : AppColors.ink,
                  letterSpacing: 0.9,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                detail,
                style: AppTypography.of(
                  12,
                  FontWeight.w500,
                  color: dark ? AppColors.darkCardSub : AppColors.metaGrey,
                ),
              ),
            ],
          ),
          if (badge != null)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                height: 22,
                padding: const EdgeInsets.symmetric(horizontal: 9),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Text(
                  badge!,
                  style: AppTypography.of(
                    11,
                    FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AddMethodCard extends StatelessWidget {
  const AddMethodCard({super.key, required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.addBorder, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.tile,
                shape: BoxShape.circle,
              ),
              child: const AppIcon('plus', color: AppColors.primary),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTypography.of(
                13,
                FontWeight.w700,
                color: AppColors.ink2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
