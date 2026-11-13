import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/dotted_line.dart';
import '../../../core/widgets/status_pill.dart';
import '../domain/home.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: AppColors.white, spreadRadius: 2)],
      ),
      child: ClipOval(
        child: AppImage('avatar_user', width: size, height: size),
      ),
    );
  }
}

/// Cabecera naranja del Home.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.summary, this.onOpenTracking});

  final HomeSummary summary;
  final VoidCallback? onOpenTracking;

  @override
  Widget build(BuildContext context) {
    final current = summary.current;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 72, 24, 52),
      decoration: const BoxDecoration(
        color: AppColors.headerOrange,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const UserAvatar(size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      summary.greeting,
                      style: AppTypography.of(
                        13.5,
                        FontWeight.w500,
                        color: AppColors.headerSub,
                      ),
                    ),
                    Text(summary.userName, style: AppTypography.name),
                  ],
                ),
              ),
              const CircleIconButton(
                icon: 'bell',
                label: 'Notificaciones',
                size: 46,
                badge: true,
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Text(
                'Entrega actual',
                style: AppTypography.of(
                  13.5,
                  FontWeight.w500,
                  color: AppColors.headerSub2,
                ),
              ),
              const SizedBox(width: 8),
              StatusPill(label: current.status),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(current.trackingNumber, style: AppTypography.trackingNumber),
              CircleIconButton(
                icon: 'arrow-ur',
                label: 'Abrir entrega',
                size: 54,
                dark: true,
                iconSize: 22,
                onPressed: onOpenTracking,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Fmt.date(current.sentOn),
                style: AppTypography.of(
                  12.5,
                  FontWeight.w500,
                  color: AppColors.headerSub,
                ),
              ),
              Text(
                'Est. ${Fmt.date(current.estimatedOn)}',
                style: AppTypography.of(
                  12.5,
                  FontWeight.w500,
                  color: AppColors.headerSub,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _ProgressRow(),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow();

  static const Widget _line = Expanded(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: DottedLine(color: AppColors.progressDot),
    ),
  );

  static const Widget _lineLight = Expanded(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: DottedLine(color: AppColors.progressDotLight),
    ),
  );

  static Widget _done() {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.pillDark,
        shape: BoxShape.circle,
      ),
      child: const AppIcon(
        'check',
        size: 12,
        color: AppColors.white,
        strokeWidth: 3,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _done(),
        _line,
        _done(),
        _line,
        Container(
          width: 40,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(13),
          ),
          child: const AppImage('service_truck', width: 26, height: 20),
        ),
        _lineLight,
        Container(
          width: 20,
          height: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.progressRing, width: 1.5),
          ),
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.progressDotLight,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
