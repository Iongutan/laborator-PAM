import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/home_models.dart';
import '../../logic/favorites/favorites_cubit.dart';
import '../../logic/programs/program_query.dart';
import '../../logic/programs/programs_cubit.dart';
import '../../logic/programs/programs_state.dart';
import '../navigation.dart';
import '../widgets/category_chip.dart';
import '../widgets/program_grid.dart';
import '../widgets/search_field.dart';
import '../widgets/simple_top_bar.dart';
import '../widgets/state_views.dart';

/// „See All” pentru Workout Programs: căutare, filtrare, sortare, favorite.
class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({super.key});

  static const double _gutter = 24;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyscale0,
      appBar: const SimpleTopBar(title: 'Workout Programs'),
      body: BlocBuilder<ProgramsCubit, ProgramsState>(
        builder: (context, state) {
          final Set<String> favorites = context.watch<FavoritesCubit>().state;
          final List<WorkoutProgram> visible = state.visible(favorites);
          final ProgramsCubit cubit = context.read<ProgramsCubit>();

          return ListView(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _gutter),
                child: SearchField(
                  initialValue: state.query,
                  onChanged: cubit.search,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 30,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: _gutter),
                  itemCount: state.filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) {
                    final ProgramFilter f = state.filters[i];
                    return CategoryChip(
                      label: f.name,
                      selected: f.id == state.selectedFilterId,
                      onTap: () => cubit.selectFilter(f.id),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _gutter),
                child: Row(
                  children: [
                    Text(
                      '${visible.length} result${visible.length == 1 ? '' : 's'}',
                      style: AppTextStyles.smallMedium
                          .copyWith(color: AppColors.greyscale400),
                    ),
                    const Spacer(),
                    _FavoritesOnlyToggle(
                      key: const Key('favorites-only'),
                      active: state.favoritesOnly,
                      count: favorites.length,
                      onTap: cubit.toggleFavoritesOnly,
                    ),
                    const SizedBox(width: 8),
                    _SortMenu(current: state.sort, onSelected: cubit.sortBy),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _gutter),
                child: visible.isEmpty
                    ? SizedBox(
                        height: 280,
                        child: MessageView.empty(
                          title: 'No programs found',
                          message: state.favoritesOnly && favorites.isEmpty
                              ? 'Tap the heart on a program to add it to favorites.'
                              : 'Try another search, filter or sort option.',
                          actionLabel: 'Clear filters',
                          onAction: cubit.clear,
                        ),
                      )
                    : ProgramGrid(
                        programs: visible,
                        favoriteIds: favorites,
                        onTap: (_) => openGymDetails(context),
                        onFavoriteToggle: (p) {
                          final FavoritesCubit fav =
                              context.read<FavoritesCubit>();
                          final bool wasFavorite = fav.isFavorite(p.id);
                          fav.toggle(p.id);
                          showAppMessage(
                            context,
                            wasFavorite
                                ? '${p.title} removed from favorites'
                                : '${p.title} added to favorites',
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FavoritesOnlyToggle extends StatelessWidget {
  const _FavoritesOnlyToggle({
    super.key,
    required this.active,
    required this.count,
    required this.onTap,
  });

  final bool active;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Favorites only',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: active ? AppColors.primary500 : AppColors.greyscale0,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: active ? AppColors.primary500 : AppColors.greyscale100,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                active ? Icons.favorite : Icons.favorite_border,
                size: 16,
                color: active ? AppColors.greyscale0 : AppColors.error100,
              ),
              const SizedBox(width: 4),
              Text(
                '$count',
                style: AppTextStyles.smallMedium.copyWith(
                  color: active ? AppColors.greyscale0 : AppColors.greyscale400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SortMenu extends StatelessWidget {
  const _SortMenu({required this.current, required this.onSelected});

  final ProgramSort current;
  final ValueChanged<ProgramSort> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ProgramSort>(
      tooltip: 'Sort',
      initialValue: current,
      onSelected: onSelected,
      color: AppColors.greyscale0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (_) => [
        for (final ProgramSort s in ProgramSort.values)
          PopupMenuItem<ProgramSort>(
            value: s,
            child: Text(
              s.label,
              style: AppTextStyles.smallMedium.copyWith(
                color: s == current
                    ? AppColors.primary500
                    : AppColors.greyscale900,
              ),
            ),
          ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.greyscale100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sort, size: 16, color: AppColors.greyscale400),
            const SizedBox(width: 4),
            Text(
              'Sort',
              style: AppTextStyles.smallMedium
                  .copyWith(color: AppColors.greyscale400),
            ),
          ],
        ),
      ),
    );
  }
}
