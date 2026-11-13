import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/rotating_hint.dart';

const List<String> kSearchHints = [
  'Ingresa tu número de rastreo',
  'Prueba "AB-889641"',
];

/// Buscador blanco de forma píldora con texto rotativo.
class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key, this.height = 58, this.shadow = true});

  final double height;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(29),
        boxShadow:
            shadow
                ? const [
                  ...AppShadows.floating,
                  BoxShadow(color: AppColors.searchRing, spreadRadius: 1),
                ]
                : null,
      ),
      child: const Row(
        children: [
          AppIcon('search', color: AppColors.searchIcon),
          SizedBox(width: 12),
          Expanded(child: RotatingHint(hints: kSearchHints)),
        ],
      ),
    );
  }
}
