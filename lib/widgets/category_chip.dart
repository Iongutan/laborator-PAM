import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Chip de filtrare pentru „Workout Programs” (Fill / Outlined).
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary500 : AppColors.greyscale0,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppColors.primary500 : AppColors.greyscale100,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.smallMedium.copyWith(
            color: selected ? AppColors.greyscale0 : AppColors.greyscale400,
          ),
        ),
      ),
    );
  }
}
