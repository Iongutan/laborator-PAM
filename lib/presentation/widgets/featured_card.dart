import 'package:flutter/material.dart';

import '../../core/constants/app_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/home_models.dart';
import 'app_network_icon.dart';
import 'app_network_image.dart';
import 'primary_button.dart';

/// Cardul „Featured Plan” (296 × 144).
class FeaturedCard extends StatelessWidget {
  const FeaturedCard({
    super.key,
    required this.plan,
    required this.onStart,
    this.width = defaultWidth,
  });

  final FeaturedPlan plan;
  final VoidCallback onStart;
  final double width;

  static const double defaultWidth = 296;
  static const double height = 144;

  @override
  Widget build(BuildContext context) {
    final TextStyle meta =
        AppTextStyles.xSmallRegular.copyWith(color: AppColors.greyscale0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppNetworkImage(url: plan.imageUrl),
            // Umbră spre stânga, ca textul alb să se citească pe orice poză.
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xB30D0D12), Color(0x000D0D12)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.h6
                            .copyWith(color: AppColors.greyscale0),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          AppNetworkIcon(
                            url: plan.durationIconUrl,
                            fallbackAsset: AppIcons.barbell,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(plan.duration, style: meta),
                          const SizedBox(width: 8),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: AppColors.greyscale0,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          AppNetworkIcon(
                            url: plan.frequencyIconUrl,
                            fallbackAsset: AppIcons.barbell,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(plan.frequency, style: meta),
                        ],
                      ),
                    ],
                  ),
                  PrimaryButton.small(
                      label: plan.actionLabel, onPressed: onStart),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
