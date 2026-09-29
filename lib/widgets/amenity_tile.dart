import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/fitness_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Căsuța dintr-o facilitate a sălii (Showers, Lockers, Wi-fi…).
class AmenityTile extends StatelessWidget {
  const AmenityTile({super.key, required this.amenity});

  final Amenity amenity;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.greyscale25,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.greyscale100),
      ),
      child: Row(
        children: [
          SvgPicture.asset(amenity.icon, width: 20, height: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              amenity.label,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.smallRegular
                  .copyWith(color: AppColors.greyscale400),
            ),
          ),
        ],
      ),
    );
  }
}
