import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'app_image.dart';

class ServiceTile extends StatelessWidget {
  const ServiceTile({
    super.key,
    required this.image,
    required this.label,
    this.imageSize = 50,
  });

  final String image;
  final String label;
  final double imageSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 70,
          height: 70,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.tile,
            borderRadius: BorderRadius.circular(20),
          ),
          child: AppImage(image, width: imageSize, height: imageSize),
        ),
        const SizedBox(height: 9),
        Text(label, style: AppTypography.of(13, FontWeight.w600)),
      ],
    );
  }
}
