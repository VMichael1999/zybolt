import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_typography.dart';
import 'app_image.dart';
import 'corner_ribbon.dart';
import 'info_cell.dart';
import 'shipment_stepper.dart';

class ParcelCard extends StatelessWidget {
  const ParcelCard({
    super.key,
    required this.id,
    required this.name,
    required this.image,
    required this.ribbonLabel,
    required this.ribbonColor,
    required this.current,
    required this.awayLabel,
    required this.fromLabel,
    required this.toLabel,
    required this.from,
    required this.fromDate,
    required this.to,
    required this.toDate,
    this.onTap,
  });

  final String id;
  final String name;
  final String image;
  final String ribbonLabel;
  final Color ribbonColor;
  final int current;
  final String awayLabel;
  final String fromLabel;
  final String toLabel;
  final String from;
  final String fromDate;
  final String to;
  final String toDate;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            ...AppShadows.card,
            BoxShadow(color: AppColors.cardBorder, spreadRadius: 1),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: ColoredBox(
            color: AppColors.white,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Header(id: id, name: name, image: image),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 40, 4, 22),
                        child: ShipmentStepper(
                          current: current,
                          awayLabel: awayLabel,
                        ),
                      ),
                      InfoGrid(
                        rows: [
                          [
                            InfoCell(
                              label: fromLabel,
                              value: from,
                              sub: fromDate,
                              caps: true,
                            ),
                            InfoCell(
                              label: toLabel,
                              value: to,
                              sub: toDate,
                              caps: true,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  right: -8,
                  bottom: -10,
                  child: AppImage('parcel_boxes', width: 118, height: 104),
                ),
                CornerRibbon(label: ribbonLabel, color: ribbonColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.id, required this.name, required this.image});

  final String id;
  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 46,
          height: 46,
          child: Center(child: AppImage(image, width: 44, height: 44)),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: $id', style: AppTypography.cardTitle),
            const SizedBox(height: 2),
            Text(
              name,
              style: AppTypography.of(
                13,
                FontWeight.w500,
                color: AppColors.metaGrey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
