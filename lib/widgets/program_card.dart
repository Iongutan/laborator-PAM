import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/fitness_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Cardul din „Workout Programs” (înălțime 184, gradient negru jos).
class ProgramCard extends StatelessWidget {
  const ProgramCard({super.key, required this.program, required this.onTap});

  final WorkoutProgram program;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextStyle meta =
        AppTextStyles.xxSmallSemibold.copyWith(color: AppColors.greyscale200);

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 184,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                program.image,
                fit: BoxFit.cover,
                alignment: program.imageAlignment,
              ),
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
                    if (program.isPro)
                      const Align(
                        alignment: Alignment.topRight,
                        child: _ProBadge(),
                      ),
                    const Spacer(),
                    Text(
                      program.title,
                      style: AppTextStyles.mediumSemibold
                          .copyWith(color: AppColors.greyscale0),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _Meta(
                          icon: AppIcons.flame,
                          label: '${program.kcal} kcl',
                          style: meta,
                        ),
                        _Meta(
                          icon: AppIcons.clock,
                          label: '${program.minutes} min',
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
  const _Meta({required this.icon, required this.label, required this.style});

  final String icon;
  final String label;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(icon, width: 12, height: 12),
        const SizedBox(width: 3),
        Text(label, style: style),
      ],
    );
  }
}

class _ProBadge extends StatelessWidget {
  const _ProBadge();

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
          SvgPicture.asset(AppIcons.crown, width: 14, height: 14),
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
