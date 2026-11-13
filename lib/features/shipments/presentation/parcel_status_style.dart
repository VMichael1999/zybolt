import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/shipments.dart';
import 'shipments_bloc.dart';

/// Strategy: a partir del estado devuelve cómo se pinta.
class ParcelStatusStyle {
  const ParcelStatusStyle({
    required this.ribbonColor,
    required this.ribbonLabel,
    required this.pillLabel,
    required this.chipLabel,
  });

  final Color ribbonColor;
  final String ribbonLabel;
  final String pillLabel;
  final String chipLabel;

  static const Map<ParcelStatus, ParcelStatusStyle> _styles = {
    ParcelStatus.transit: ParcelStatusStyle(
      ribbonColor: AppColors.ribbonTransit,
      ribbonLabel: 'En camino',
      pillLabel: 'En camino',
      chipLabel: 'Tránsito',
    ),
    ParcelStatus.process: ParcelStatusStyle(
      ribbonColor: AppColors.ribbonProcess,
      ribbonLabel: 'En proceso',
      pillLabel: 'En proceso',
      chipLabel: 'Proceso',
    ),
    ParcelStatus.delivered: ParcelStatusStyle(
      ribbonColor: AppColors.ribbonDelivered,
      ribbonLabel: 'Entregado',
      pillLabel: 'Entregado',
      chipLabel: 'Entregado',
    ),
  };

  static ParcelStatusStyle of(ParcelStatus status) => _styles[status]!;

  static String filterLabel(ShipmentsFilter f) {
    switch (f) {
      case ShipmentsFilter.all:
        return 'Todos';
      case ShipmentsFilter.transit:
        return 'En camino';
      case ShipmentsFilter.process:
        return 'En proceso';
      case ShipmentsFilter.delivered:
        return 'Entregados';
    }
  }
}
