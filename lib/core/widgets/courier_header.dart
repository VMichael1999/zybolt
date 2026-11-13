import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'app_icon.dart';
import 'app_image.dart';
import 'buttons.dart';

class CourierHeader extends StatelessWidget {
  const CourierHeader({
    super.key,
    required this.role,
    required this.rating,
    required this.name,
    required this.callLabel,
    required this.chatLabel,
  });

  final String role;
  final String rating;
  final String name;
  final String callLabel;
  final String chatLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: AppColors.avatarBg,
            shape: BoxShape.circle,
          ),
          child: const ClipOval(
            child: AppImage('avatar_courier', width: 50, height: 50),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    role,
                    style: AppTypography.of(
                      12.5,
                      FontWeight.w500,
                      color: AppColors.metaGrey,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const AppIcon(
                    'star',
                    size: 13,
                    color: AppColors.primary,
                    solid: true,
                  ),
                  const SizedBox(width: 5),
                  Text(rating, style: AppTypography.of(12.5, FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 1),
              Text(name, style: AppTypography.of(18, FontWeight.w800)),
            ],
          ),
        ),
        CircleIconButton(icon: 'phone', label: callLabel, size: 50, dark: true),
        const SizedBox(width: 10),
        CircleIconButton(
          icon: 'chat',
          label: chatLabel,
          size: 50,
          dark: true,
          solidIcon: true,
        ),
      ],
    );
  }
}
