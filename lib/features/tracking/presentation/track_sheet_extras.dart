import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/profile_card.dart';

/// Datos extra del repartidor: estadísticas y vehículo.
class CourierExtras extends StatelessWidget {
  const CourierExtras({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        children: [
          const ProfileStatsRow(
            stats: [
              ProfileStat('1,284', 'Entregas'),
              ProfileStat('98%', 'A tiempo'),
              ProfileStat('3 años', 'En Zybolt'),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const AppIcon('truck', color: AppColors.iconBoxFg),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Honda CB 190R · Moto',
                        style: AppTypography.of(14, FontWeight.w700),
                      ),
                      Text(
                        'Placa 4821-PRX · Mochila térmica',
                        style: AppTypography.of(
                          12,
                          FontWeight.w500,
                          color: AppColors.metaGrey,
                        ),
                      ),
                    ],
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

class SheetTitle extends StatelessWidget {
  const SheetTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 26, bottom: 14),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: AppTypography.section),
      ),
    );
  }
}

/// Detalles del paquete.
class PackageDetails extends StatelessWidget {
  const PackageDetails({super.key});

  static const List<(String, String)> _rows = [
    ('Peso', '2.4 kg'),
    ('Tamaño', 'Mediano · 35×25×15 cm'),
    ('Seguro', 'Incluido'),
    ('Pago', 'Tarjeta •••• 4417'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < _rows.length; i++)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                border:
                    i == 0
                        ? null
                        : const Border(
                          top: BorderSide(color: AppColors.lineSoft),
                        ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _rows[i].$1,
                    style: AppTypography.of(
                      14,
                      FontWeight.w500,
                      color: AppColors.metaGrey,
                    ),
                  ),
                  Text(
                    _rows[i].$2,
                    style: AppTypography.of(14, FontWeight.w700),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
