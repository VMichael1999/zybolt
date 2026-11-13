import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_typography.dart';
import 'app_image.dart';
import 'info_cell.dart';
import 'shipment_stepper.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.title,
    required this.chip,
    required this.number,
    required this.current,
    required this.awayLabel,
    required this.cells,
    this.stepLabels,
  });

  final String title;
  final String chip;
  final String number;
  final int current;
  final String? awayLabel;

  /// Cuatro celdas: origen, destino, costo y cliente (etiqueta, valor).
  final List<(String, String)> cells;

  /// Pasos con su hora, bajo el stepper (sustituye al historial).
  final List<StepLabel>? stepLabels;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          ...AppShadows.bookingCard,
          BoxShadow(color: AppColors.sheetBorder, spreadRadius: 1),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: ColoredBox(
          color: AppColors.white,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: AppTypography.of(
                            13.5,
                            FontWeight.w500,
                            color: AppColors.metaGrey,
                          ),
                        ),
                        Container(
                          height: 32,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.dark,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            chip,
                            style: AppTypography.of(
                              13,
                              FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(number, style: AppTypography.bookingNumber),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 34,
                        bottom: stepLabels == null ? 20 : 58,
                      ),
                      child: ShipmentStepper(
                        current: current,
                        awayLabel: awayLabel,
                        labels: stepLabels,
                      ),
                    ),
                    InfoGrid(
                      rowGap: 12,
                      rows: [
                        [
                          InfoCell(label: cells[0].$1, value: cells[0].$2),
                          InfoCell(label: cells[1].$1, value: cells[1].$2),
                        ],
                        [
                          InfoCell(label: cells[2].$1, value: cells[2].$2),
                          InfoCell(label: cells[3].$1, value: cells[3].$2),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Positioned(
                right: -6,
                bottom: -8,
                child: AppImage('parcel_boxes', width: 126, height: 110),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
