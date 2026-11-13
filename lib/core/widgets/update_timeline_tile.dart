import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'app_icon.dart';

enum UpdateKind { live, normal, success }

class UpdateTimelineTile extends StatelessWidget {
  const UpdateTimelineTile({
    super.key,
    required this.time,
    required this.title,
    required this.detail,
    required this.icon,
    required this.kind,
    this.liveLabel = 'En vivo',
    this.isLast = false,
    this.active = false,
    this.timeMuted = false,
  });

  final String time;
  final String title;
  final String detail;
  final String icon;
  final UpdateKind kind;
  final String liveLabel;
  final bool isLast;
  final bool active;
  final bool timeMuted;

  @override
  Widget build(BuildContext context) {
    final live = kind == UpdateKind.live;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CustomPaint(
        painter: isLast ? null : _LinePainter(),
        child: Row(
          children: [
            SizedBox(
              width: 52,
              child: Text(
                time,
                textAlign: TextAlign.right,
                style: AppTypography.of(
                  11.5,
                  timeMuted ? FontWeight.w500 : FontWeight.w700,
                  color: timeMuted ? AppColors.timelineHint : AppColors.ink,
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(width: 14, child: Center(child: _Dot(active: active))),
            const SizedBox(width: 8),
            Expanded(child: _Card(this, live)),
          ],
        ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final top = size.height / 2 + 7;
    canvas.drawRect(
      Rect.fromLTWH(66, top, 1.5, size.height - 4),
      Paint()..color = AppColors.timelineLine,
    );
  }

  @override
  bool shouldRepaint(_LinePainter old) => false;
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? AppColors.primary : AppColors.white,
        border:
            active
                ? null
                : Border.all(color: AppColors.timelineDotRing, width: 1.5),
        boxShadow:
            active
                ? const [BoxShadow(color: AppColors.transitBg, spreadRadius: 3)]
                : null,
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card(this.t, this.live);

  final UpdateTimelineTile t;
  final bool live;

  @override
  Widget build(BuildContext context) {
    final success = t.kind == UpdateKind.success;
    final Color boxBg =
        live
            ? AppColors.transitBg
            : (success ? AppColors.greenSoft : AppColors.tile);
    final Color boxFg =
        live
            ? AppColors.primary
            : (success ? AppColors.green : AppColors.iconBoxFg);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: live ? AppColors.liveFill : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: live ? AppColors.liveBorder : AppColors.line,
          width: live ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: boxBg,
              borderRadius: BorderRadius.circular(11),
            ),
            child: AppIcon(t.icon, color: boxFg),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.title, style: AppTypography.of(14, FontWeight.w700)),
                const SizedBox(height: 1),
                Text(
                  t.detail,
                  style: AppTypography.of(
                    12,
                    FontWeight.w500,
                    color: AppColors.metaGrey,
                  ),
                ),
              ],
            ),
          ),
          if (live)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 22,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: AppColors.liveChipBorder),
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
                    const SizedBox(width: 4),
                    Text(
                      t.liveLabel,
                      style: AppTypography.of(11, FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
