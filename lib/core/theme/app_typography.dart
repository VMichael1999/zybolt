import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Escala tipográfica (Plus Jakarta Sans). Altura de línea 1.3 como en el HTML.
abstract final class AppTypography {
  static const String family = 'PlusJakartaSans';

  /// Estilo suelto para tamaños que no tienen nombre propio.
  static TextStyle of(
    double size,
    FontWeight weight, {
    Color color = AppColors.ink,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      fontFamily: family,
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: 1.3,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  static const TextStyle display = TextStyle(
    fontFamily: family,
    fontSize: 38,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.76,
    color: AppColors.splashInk,
    height: 1.3,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle trackingNumber = TextStyle(
    fontFamily: family,
    fontSize: 31,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.31,
    color: AppColors.ink,
    height: 1.3,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle bookingNumber = TextStyle(
    fontFamily: family,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.28,
    color: AppColors.ink,
    height: 1.3,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle title = TextStyle(
    fontFamily: family,
    fontSize: 25,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    color: AppColors.ink,
    height: 1.3,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle welcome = TextStyle(
    fontFamily: family,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.48,
    color: AppColors.ink,
    height: 1.3,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle screenTitle = TextStyle(
    fontFamily: family,
    fontSize: 20,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.2,
    color: AppColors.ink,
    height: 1.3,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle name = TextStyle(
    fontFamily: family,
    fontSize: 19,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.19,
    color: AppColors.ink,
    height: 1.3,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle section = TextStyle(
    fontFamily: family,
    fontSize: 18,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.18,
    color: AppColors.ink,
    height: 1.3,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: family,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
    height: 1.3,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle button = TextStyle(
    fontFamily: family,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
    height: 1.3,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle body = TextStyle(
    fontFamily: family,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.ink,
    height: 1.3,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle label = TextStyle(
    fontFamily: family,
    fontSize: 13.5,
    fontWeight: FontWeight.w500,
    color: AppColors.ink,
    height: 1.3,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: family,
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
    color: AppColors.ink,
    height: 1.3,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle micro = TextStyle(
    fontFamily: family,
    fontSize: 11.5,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
    height: 1.3,
    leadingDistribution: TextLeadingDistribution.even,
  );
}
