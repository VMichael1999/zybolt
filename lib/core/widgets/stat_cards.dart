import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'app_icon.dart';

/// Cuadro blanco de 30 con ícono.
class IconSquare extends StatelessWidget {
  const IconSquare({
    super.key,
    required this.icon,
    this.color = AppColors.primary,
    this.background = AppColors.white,
  });

  final String icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(9),
      ),
      child: AppIcon(icon, size: 16, color: color),
    );
  }
}

class WeeklyBar {
  const WeeklyBar({
    required this.label,
    required this.height,
    this.highlight = false,
    this.muted = false,
    this.value,
  });

  final String label;
  final double height;
  final bool highlight;
  final bool muted;
  final String? value;
}

/// Barras de 12 de ancho y radio 6; la resaltada va en naranja con su número.
class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({super.key, required this.bars});

  final List<WeeklyBar> bars;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final b in bars)
              SizedBox(
                width: 16,
                child: OverflowBox(
                  alignment: Alignment.bottomCenter,
                  minHeight: 0,
                  maxHeight: double.infinity,
                  child: _Column(b),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Column extends StatelessWidget {
  const _Column(this.bar);

  final WeeklyBar bar;

  @override
  Widget build(BuildContext context) {
    final color =
        bar.highlight
            ? AppColors.primary
            : (bar.muted ? AppColors.barMuted : AppColors.barBase);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 12,
          child: Text(
            bar.value ?? '',
            style: AppTypography.of(11, FontWeight.w800),
            maxLines: 1,
            overflow: TextOverflow.visible,
            softWrap: false,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 12,
          height: bar.height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          bar.label,
          softWrap: false,
          style: AppTypography.of(
            10.5,
            FontWeight.w600,
            color: bar.highlight ? AppColors.ink : AppColors.metaWarm,
          ),
        ),
      ],
    );
  }
}

/// Tarjeta grande «Paquetes enviados» con la gráfica semanal.
class WeeklyStatCard extends StatelessWidget {
  const WeeklyStatCard({
    super.key,
    required this.title,
    required this.range,
    required this.total,
    required this.delta,
    required this.bars,
  });

  final String title;
  final String range;
  final String total;
  final String delta;
  final List<WeeklyBar> bars;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.peach,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconSquare(icon: 'box'),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.of(13.5, FontWeight.w700)),
                    Text(
                      range,
                      style: AppTypography.of(
                        11.5,
                        FontWeight.w500,
                        color: AppColors.metaWarm,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(total, style: AppTypography.of(34, FontWeight.w800)),
              Container(
                height: 24,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const AppIcon(
                      'trend',
                      size: 13,
                      color: AppColors.greenTrend,
                      strokeWidth: 2.4,
                    ),
                    const SizedBox(width: 4),
                    Text(delta, style: AppTypography.of(11.5, FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          WeeklyBarChart(bars: bars),
        ],
      ),
    );
  }
}

/// Tarjeta pequeña de métrica (98 % a tiempo, gasto).
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.leading,
    required this.value,
    required this.label,
    this.detail,
  });

  final Widget leading;
  final String value;
  final String label;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leading,
          const SizedBox(height: 12),
          Text(value, style: AppTypography.of(22, FontWeight.w800)),
          Text(label, style: AppTypography.of(12.5, FontWeight.w600)),
          if (detail != null)
            Text(
              detail!,
              style: AppTypography.of(
                11.5,
                FontWeight.w500,
                color: AppColors.metaGrey,
              ),
            ),
        ],
      ),
    );
  }
}

/// Círculo con borde naranja y rayo.
class BoltBadge extends StatelessWidget {
  const BoltBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: const AppIcon('bolt', size: 17, color: AppColors.primary),
    );
  }
}
