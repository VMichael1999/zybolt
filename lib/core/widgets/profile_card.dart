import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_typography.dart';
import 'app_icon.dart';
import 'app_image.dart';

class ProfileStat {
  const ProfileStat(this.value, this.label);

  final String value;
  final String label;
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.name,
    required this.email,
    required this.editLabel,
    required this.stats,
    required this.membership,
    required this.membershipDetail,
    required this.progress,
  });

  final String name;
  final String email;
  final String editLabel;
  final List<ProfileStat> stats;
  final String membership;
  final String membershipDetail;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          ...AppShadows.card,
          BoxShadow(color: AppColors.cardBorder, spreadRadius: 1),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(color: AppColors.transitBg, spreadRadius: 3),
                  ],
                ),
                child: const ClipOval(
                  child: AppImage('avatar_user', width: 64, height: 64),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTypography.of(19, FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(
                      email,
                      style: AppTypography.of(
                        13,
                        FontWeight.w500,
                        color: AppColors.metaGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.dark,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const AppIcon('edit', size: 14, color: AppColors.white),
                    const SizedBox(width: 6),
                    Text(
                      editLabel,
                      style: AppTypography.of(
                        12.5,
                        FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ProfileStatsRow(stats: stats),
          const SizedBox(height: 12),
          MembershipBanner(
            title: membership,
            detail: membershipDetail,
            progress: progress,
          ),
        ],
      ),
    );
  }
}

class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({super.key, required this.stats});

  final List<ProfileStat> stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            for (var i = 0; i < stats.length; i++)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 6,
                  ),
                  decoration: BoxDecoration(
                    border:
                        i == 0
                            ? null
                            : const Border(
                              left: BorderSide(color: AppColors.statDivider),
                            ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        stats[i].value,
                        style: AppTypography.of(17, FontWeight.w800),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        stats[i].label,
                        style: AppTypography.of(
                          11.5,
                          FontWeight.w500,
                          color: AppColors.metaGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class MembershipBanner extends StatelessWidget {
  const MembershipBanner({
    super.key,
    required this.title,
    required this.detail,
    required this.progress,
  });

  final String title;
  final String detail;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.peach,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const AppIcon('crown', size: 22, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.of(14, FontWeight.w800)),
                Text(
                  detail,
                  style: AppTypography.of(
                    12,
                    FontWeight.w500,
                    color: AppColors.levelSub,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Container(
                    height: 6,
                    color: AppColors.white,
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
