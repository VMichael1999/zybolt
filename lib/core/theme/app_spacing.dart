import 'package:flutter/material.dart';

abstract final class AppSpacing {
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s10 = 10;
  static const double s12 = 12;
  static const double s14 = 14;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s22 = 22;
  static const double s24 = 24;
  static const double s30 = 30;

  /// Margen lateral de las pantallas (24 en login y cabecera del Home).
  static const double screen = 22;
  static const double screenWide = 24;

  /// Espacio inferior para que el contenido no quede bajo la barra flotante.
  static const double navClearance = 150;
}

abstract final class AppRadius {
  static const double pill = 28;
  static const double shipmentCard = 22;
  static const double metric = 20;
  static const double service = 20;
  static const double activeShipment = 18;
  static const double sheet = 30;
  static const double homeHeader = 36;
  static const double compactHeader = 28;
  static const double nav = 34;

  static BorderRadius get pillRadius => BorderRadius.circular(pill);
  static BorderRadius circular(double r) => BorderRadius.circular(r);
}
