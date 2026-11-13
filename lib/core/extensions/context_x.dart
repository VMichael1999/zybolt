import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

extension ContextX on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
  bool get reduceMotion => MediaQuery.disableAnimationsOf(this);
}
