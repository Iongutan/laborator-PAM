import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Butonul verde „Primary” din design (XSmall = 32px, Large = 52px).
class PrimaryButton extends StatelessWidget {
  const PrimaryButton.small({
    super.key,
    required this.label,
    required this.onPressed,
  })  : height = 32,
        radius = 6,
        large = false;

  const PrimaryButton.large({
    super.key,
    required this.label,
    required this.onPressed,
  })  : height = 52,
        radius = 12,
        large = true;

  final String label;
  final VoidCallback? onPressed;
  final double height;
  final double radius;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final TextStyle style =
        (large ? AppTextStyles.mediumSemibold : AppTextStyles.xSmallSemibold)
            .copyWith(color: AppColors.greyscale0);

    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F0D0D12),
              offset: Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Material(
          color: AppColors.primary500,
          borderRadius: BorderRadius.circular(radius),
          child: InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                widthFactor: 1,
                child: Text(label, style: style),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
