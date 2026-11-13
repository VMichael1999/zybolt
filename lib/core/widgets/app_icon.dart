import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import 'icon_paths.dart';

String _hex(Color c) =>
    '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

String _opacity(Color c) => (c.a).toStringAsFixed(3);

/// Ícono de línea (Tabler) dibujado desde los mismos paths del HTML.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.name, {
    super.key,
    this.size = 20,
    this.color = AppColors.ink,
    this.strokeWidth = 1.9,
    this.fillColor,
    this.solid = false,
  });

  final String name;
  final double size;
  final Color color;
  final double strokeWidth;

  /// Relleno del trazo cerrado (por ejemplo, el ícono activo de la barra).
  final Color? fillColor;

  /// Dibuja el ícono relleno y sin trazo (estrella, chat, enviar).
  final bool solid;

  String _svg() {
    final body = kIconPaths[name] ?? '';
    final String attrs;
    if (solid) {
      attrs =
          'fill="${_hex(color)}" fill-opacity="${_opacity(color)}" '
          'stroke="none"';
    } else {
      final fill =
          fillColor == null
              ? 'fill="none"'
              : 'fill="${_hex(fillColor!)}" fill-opacity="${_opacity(fillColor!)}"';
      attrs =
          '$fill stroke="${_hex(color)}" '
          'stroke-opacity="${_opacity(color)}" '
          'stroke-width="$strokeWidth" stroke-linecap="round" '
          'stroke-linejoin="round"';
    }
    return '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" '
        '$attrs>$body</svg>';
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(_svg(), width: size, height: size);
  }
}
