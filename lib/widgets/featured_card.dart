import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/fitness_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'primary_button.dart';

/// Cardul „Featured Plan” (296 × 144).
class FeaturedCard extends StatelessWidget {
  const FeaturedCard({super.key, required this.plan, required this.onStart});

  final FeaturedPlan plan;
  final VoidCallback onStart;

  static const double width = 296;
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
          children: [
            // Imaginea e mărită la 115.5% × 158% și ancorată sus-stânga,
            // exact ca în Figma.
            Positioned(
              left: 0,
              top: 0,
              width: width * 1.155,
              height: height * 1.58,
              child: Image.asset(plan.image, fit: BoxFit.cover),
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
                        style: AppTextStyles.h6
                            .copyWith(color: AppColors.greyscale0),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          SvgPicture.asset(AppIcons.barbell,
                              width: 16, height: 16),
                          const SizedBox(width: 4),
                          Text('${plan.weeks} week', style: meta),
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
                          Text('${plan.timesPerWeek}x/week', style: meta),
                        ],
                      ),
                    ],
                  ),
                  PrimaryButton.small(label: 'Start Now', onPressed: onStart),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
