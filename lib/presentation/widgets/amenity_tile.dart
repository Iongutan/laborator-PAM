import 'package:flutter/material.dart';

import '../../core/constants/app_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/gym_models.dart';
import 'app_network_icon.dart';

/// Căsuța unei facilități a sălii (Showers, Lockers…).
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
          AppNetworkIcon(
            url: amenity.iconUrl,
            asset: AppIcons.amenity(amenity.id),
            size: 20,
            color: AppColors.greyscale400,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              amenity.name,
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
