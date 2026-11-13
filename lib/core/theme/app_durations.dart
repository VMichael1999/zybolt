import 'package:flutter/animation.dart';

abstract final class AppDurations {
  static const Duration screenFade = Duration(milliseconds: 350);
  static const Duration fieldFocus = Duration(milliseconds: 150);
  static const Duration overlay = Duration(milliseconds: 300);
  static const Duration compactHeader = Duration(milliseconds: 280);
  static const Duration hintSwap = Duration(milliseconds: 250);
  static const Duration hintEvery = Duration(milliseconds: 3200);
  static const Duration splash = Duration(milliseconds: 3200);
  static const Duration splashHold = Duration(milliseconds: 400);
  static const Duration splashReduced = Duration(milliseconds: 1500);
  static const Duration brandDelay = Duration(milliseconds: 1100);
  static const Duration brandFade = Duration(milliseconds: 700);
  static const Duration signingIn = Duration(milliseconds: 1700);
  static const Duration searching = Duration(milliseconds: 1500);
  static const Duration trackingWait = Duration(milliseconds: 600);
  static const Duration trackingRun = Duration(milliseconds: 11000);
  static const Duration trackingDeliver = Duration(milliseconds: 700);
  static const Duration trackingTick = Duration(milliseconds: 100);
  static const Duration banner = Duration(milliseconds: 300);
  static const Duration toggle = Duration(milliseconds: 200);
  static const Duration bob = Duration(seconds: 1);
  static const Duration debounce = Duration(milliseconds: 250);
}

abstract final class AppCurves {
  static const Cubic compactHeader = Cubic(0.2, 0.8, 0.2, 1);
  static const Cubic splash = Cubic(0.45, 0, 0.3, 1);
}
