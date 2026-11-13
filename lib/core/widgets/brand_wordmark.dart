import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Nombre de la app: «Zy» en tinta y «bolt» en naranja.
abstract final class Brand {
  static const String name = 'Zybolt';
  static const String first = 'Zy';
  static const String second = 'bolt';
}

class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, required this.style, this.inkColor});

  final TextStyle style;
  final Color? inkColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: Brand.name,
      excludeSemantics: true,
      child: Text.rich(
        TextSpan(
          style: style,
          children: [
            TextSpan(
              text: Brand.first,
              style: inkColor == null ? null : TextStyle(color: inkColor),
            ),
            const TextSpan(
              text: Brand.second,
              style: TextStyle(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
