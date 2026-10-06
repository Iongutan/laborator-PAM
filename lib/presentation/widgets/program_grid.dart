import 'package:flutter/material.dart';

import '../../data/models/home_models.dart';
import 'program_card.dart';

/// Grila cu 2 coloane de carduri de program (refolosită pe mai multe ecrane).
class ProgramGrid extends StatelessWidget {
  const ProgramGrid({
    super.key,
    required this.programs,
    required this.onTap,
    this.favoriteIds,
    this.onFavoriteToggle,
  });

  final List<WorkoutProgram> programs;
  final ValueChanged<WorkoutProgram> onTap;
  final Set<String>? favoriteIds;
  final ValueChanged<WorkoutProgram>? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: programs.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: ProgramCard.height,
      ),
      itemBuilder: (_, i) {
        final WorkoutProgram p = programs[i];
        return ProgramCard(
          program: p,
          onTap: () => onTap(p),
          isFavorite: favoriteIds?.contains(p.id) ?? false,
          onFavoriteToggle:
              onFavoriteToggle == null ? null : () => onFavoriteToggle!(p),
        );
      },
    );
  }
}
