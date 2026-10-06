import 'package:flutter/material.dart';

import '../../core/constants/app_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/home_models.dart';
import 'app_network_icon.dart';
import 'app_network_image.dart';

/// Cardul din „Workout Programs” (înălțime 184, gradient negru jos).
/// Dacă primește [onFavoriteToggle], afișează și inima pentru favorite.
class ProgramCard extends StatelessWidget {
  const ProgramCard({
    super.key,
    required this.program,
    required this.onTap,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  final WorkoutProgram program;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  static const double height = 184;

  @override
  Widget build(BuildContext context) {
    final TextStyle meta =
        AppTextStyles.xxSmallSemibold.copyWith(color: AppColors.greyscale200);

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AppNetworkImage(id: program.id, url: program.imageUrl),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x00000000), Color(0xCC000000)],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (onFavoriteToggle != null)
                          _FavoriteButton(
                            isFavorite: isFavorite,
                            onTap: onFavoriteToggle!,
                          ),
                        const Spacer(),
                        if (program.isPro)
                          _ProBadge(iconUrl: program.proIconUrl ?? ''),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      program.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.mediumSemibold
                          .copyWith(color: AppColors.greyscale0),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _Meta(
                          iconUrl: program.caloriesIconUrl,
                          fallback: AppIcons.flame,
                          label: '${program.calories} kcl',
                          style: meta,
                        ),
                        _Meta(
                          iconUrl: program.durationIconUrl,
                          fallback: AppIcons.clock,
                          label: '${program.durationMinutes} min',
                          style: meta,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({
    required this.iconUrl,
    required this.fallback,
    required this.label,
    required this.style,
  });

  final String iconUrl;
  final String fallback;
  final String label;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppNetworkIcon(
          url: iconUrl,
          asset: fallback,
          size: 12,
          color: AppColors.greyscale200,
        ),
        const SizedBox(width: 3),
        Text(label, style: style),
      ],
    );
  }
}

class _ProBadge extends StatelessWidget {
  const _ProBadge({required this.iconUrl});

  final String iconUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppNetworkIcon(
            url: iconUrl,
            asset: AppIcons.crown,
            size: 14,
            color: AppColors.primary500,
          ),
          const SizedBox(width: 3),
          Text(
            'Pro',
            style: AppTextStyles.xSmallMedium
                .copyWith(color: AppColors.primary500),
          ),
        ],
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.isFavorite, required this.onTap});

  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: isFavorite ? 'Remove from favorites' : 'Add to favorites',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            size: 16,
            color: isFavorite ? AppColors.error100 : AppColors.greyscale900,
          ),
        ),
      ),
    );
  }
}
