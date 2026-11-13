import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Sombras del HTML. CSS `blur` equivale a `blurRadius` y el spread negativo se respeta.
abstract final class AppShadows {
  static const List<BoxShadow> floating = [
    BoxShadow(
      color: Color(0x47000000),
      offset: Offset(0, 12),
      blurRadius: 26,
      spreadRadius: -12,
    ),
  ];

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x59000000),
      offset: Offset(0, 10),
      blurRadius: 26,
      spreadRadius: -18,
    ),
  ];

  static const List<BoxShadow> nav = [
    BoxShadow(
      color: Color(0x59000000),
      offset: Offset(0, 14),
      blurRadius: 34,
      spreadRadius: -14,
    ),
  ];

  static const List<BoxShadow> button = [
    BoxShadow(
      color: Color(0xCCEC5A12),
      offset: Offset(0, 10),
      blurRadius: 22,
      spreadRadius: -12,
    ),
  ];

  static const List<BoxShadow> social = [
    BoxShadow(
      color: Color(0x40000000),
      offset: Offset(0, 6),
      blurRadius: 16,
      spreadRadius: -10,
    ),
  ];

  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x4D000000),
      offset: Offset(0, 8),
      blurRadius: 22,
      spreadRadius: -14,
    ),
  ];

  static const List<BoxShadow> mapChip = [
    BoxShadow(
      color: AppColors.mapChipShadow,
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: -6,
    ),
  ];

  static const List<BoxShadow> circleButton = [
    BoxShadow(
      color: Color(0x59000000),
      offset: Offset(0, 6),
      blurRadius: 16,
      spreadRadius: -8,
    ),
  ];

  static const List<BoxShadow> bookingCard = [
    BoxShadow(
      color: Color(0x73000000),
      offset: Offset(0, 12),
      blurRadius: 30,
      spreadRadius: -20,
    ),
  ];

  static const List<BoxShadow> sheetTop = [
    BoxShadow(
      color: Color(0x66000000),
      offset: Offset(0, -10),
      blurRadius: 30,
      spreadRadius: -20,
    ),
  ];

  static const List<BoxShadow> compactHeader = [
    BoxShadow(
      color: Color(0x59000000),
      offset: Offset(0, 10),
      blurRadius: 24,
      spreadRadius: -16,
    ),
  ];

  static const List<BoxShadow> knob = [
    BoxShadow(
      color: AppColors.switchShadow,
      offset: Offset(0, 2),
      blurRadius: 4,
    ),
  ];
}
