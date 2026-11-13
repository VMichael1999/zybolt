import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'app_icon.dart';

class NavItem {
  const NavItem({required this.icon, required this.label});

  final String icon;
  final String label;
}

/// Barra flotante de vidrio líquido (326 × 68, a 30 del borde inferior).
///
/// Usa `GlassTabBar.bottom` de `liquid_glass_widgets`: al mantener presionado
/// y arrastrar, el indicador de vidrio sigue al dedo y se estira como en iOS.
class GlassNavBar extends StatelessWidget {
  const GlassNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const double _width = 326;
  static const double _height = 68;
  static const double _bottom = 30;

  @override
  Widget build(BuildContext context) {
    final side = (MediaQuery.sizeOf(context).width - _width) / 2;
    return Align(
      alignment: Alignment.bottomCenter,
      child: GlassTabBar.bottom(
        selectedIndex: currentIndex,
        onTabSelected: onTap,
        barHeight: _height,
        barBorderRadius: 34,
        horizontalPadding: side,
        verticalPadding: _bottom,
        iconSize: 21,
        labelFontSize: 11.5,
        selectedIconColor: AppColors.primary,
        unselectedIconColor: AppColors.navIdle,
        selectedLabelColor: AppColors.primary,
        unselectedLabelColor: AppColors.navIdle,
        selectedLabelStyle: AppTypography.of(
          11.5,
          FontWeight.w600,
          color: AppColors.primary,
        ),
        unselectedLabelStyle: AppTypography.of(
          11.5,
          FontWeight.w600,
          color: AppColors.navIdle,
        ),
        tabs: [
          for (final item in items)
            GlassTab(
              label: item.label,
              semanticLabel: item.label,
              icon: AppIcon(item.icon, size: 21, color: AppColors.navIdle),
              activeIcon: AppIcon(
                item.icon,
                size: 21,
                color: AppColors.primary,
                fillColor: AppColors.primaryFill,
              ),
            ),
        ],
      ),
    );
  }
}
