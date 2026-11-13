import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'app_image.dart';

class FlagPair extends StatelessWidget {
  const FlagPair({
    super.key,
    required this.first,
    required this.second,
    this.ring = AppColors.card,
  });

  final String first;
  final String second;
  final Color ring;

  Widget _flag(String name) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: ring, spreadRadius: 2)],
      ),
      child: ClipOval(child: AppImage(name, width: 26, height: 26)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 26 + 20,
      height: 26,
      child: Stack(
        clipBehavior: Clip.none,
        children: [_flag(first), Positioned(left: 20, child: _flag(second))],
      ),
    );
  }
}
