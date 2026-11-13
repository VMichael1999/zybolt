import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_typography.dart';
import 'app_icon.dart';
import 'app_image.dart';

class DropOffTile extends StatelessWidget {
  const DropOffTile({
    super.key,
    required this.number,
    required this.name,
    required this.detail,
    required this.status,
    required this.distance,
    required this.open,
    this.showTopLine = true,
  });

  final int number;
  final String name;
  final String detail;
  final String status;
  final String distance;
  final bool open;
  final bool showTopLine;

  @override
  Widget build(BuildContext context) {
    final statusColor = open ? AppColors.green : AppColors.metaGrey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        border:
            showTopLine
                ? const Border(top: BorderSide(color: AppColors.lineMap))
                : null,
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: open ? AppColors.dark : AppColors.closedGrey,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: AppTypography.of(
                12.5,
                FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.of(14, FontWeight.w700)),
                Text(
                  detail,
                  style: AppTypography.of(
                    12,
                    FontWeight.w500,
                    color: AppColors.metaGrey,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      status,
                      style: AppTypography.of(
                        12,
                        FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(distance, style: AppTypography.of(13.5, FontWeight.w700)),
          const SizedBox(width: 4),
          const AppIcon('chev-r', size: 15, color: AppColors.chevronGrey),
        ],
      ),
    );
  }
}

/// Mapa de 190 con pines numerados, chip «N abiertos cerca de ti».
class NearbyMap extends StatelessWidget {
  const NearbyMap({super.key, required this.openLabel, this.map});

  final String openLabel;

  /// Mapa real (Google). Si es nulo se dibuja el mapa del prototipo.
  final Widget? map;

  Widget _num(double x, double y, String n) {
    return Positioned(
      left: x - 9,
      top: y - 9,
      width: 18,
      height: 18,
      child: Center(
        child: Text(
          n,
          style: AppTypography.of(10, FontWeight.w700, color: AppColors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (map != null)
            map!
          else ...[
            const AppImage('map_nearby', width: 396, height: 190),
            _num(103, 70, '1'),
            _num(222, 35, '2'),
            _num(345, 112, '3'),
          ],
          Positioned(
            left: 12,
            top: 12,
            child: Container(
              height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 11),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: AppShadows.mapChip,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppIcon(
                    'send',
                    size: 13,
                    color: AppColors.primary,
                    solid: true,
                  ),
                  const SizedBox(width: 6),
                  Text(openLabel, style: AppTypography.of(12, FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
