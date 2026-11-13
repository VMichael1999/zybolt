import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Ilustración de `assets/images/`. Mismo tamaño y posición que en el HTML.
class AppImage extends StatelessWidget {
  const AppImage(this.name, {super.key, this.width, this.height});

  final String name;
  final double? width;
  final double? height;

  static String path(String name) => 'assets/images/$name.svg';

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(path(name), width: width, height: height);
  }
}
