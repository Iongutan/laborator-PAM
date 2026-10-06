import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/home_models.dart';
import '../../logic/home/home_cubit.dart';
import '../../logic/home/home_state.dart';
import '../../logic/load_status.dart';
import '../navigation.dart';
import '../widgets/category_chip.dart';
import '../widgets/featured_card.dart';
import '../widgets/notification_button.dart';
import '../widgets/program_card.dart';
import '../widgets/program_grid.dart';
import '../widgets/progress_ring.dart';
import '../widgets/section_header.dart';
import '../widgets/state_views.dart';

/// Ecranul „21. Home v2” din Figma, cu datele din lab_v3.json.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const double gutter = 24;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.greyscale0,
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              switch (state.status) {
                case LoadStatus.initial:
                case LoadStatus.loading:
                  return const LoadingView(message: 'Loading your workouts...');
                case LoadStatus.failure:
                  return MessageView.error(
                    message: state.errorMessage ?? 'Unknown error',
                    onRetry: () => context.read<HomeCubit>().load(),
                  );
                case LoadStatus.empty:
                  return MessageView.empty(
                    title: 'No workouts yet',
                    message: 'There are no plans or programs to show.',
                    actionLabel: 'Reload',
                    onAction: () => context.read<HomeCubit>().load(),
                  );
                case LoadStatus.success:
                  return _HomeContent(state: state);
              }
            },
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.state});

  final HomeState state;

  static const double _gutter = HomeScreen.gutter;

  @override
  Widget build(BuildContext context) {
    final FitnessHome home = state.home!;
    return RefreshIndicator(
      color: AppColors.primary500,
      onRefresh: () => context.read<HomeCubit>().load(),
      child: ListView(
        padding: const EdgeInsets.only(top: 16, bottom: 17),
        children: [
          _Greeting(header: home.header),
          const SizedBox(height: 29),
          _ChallengeCard(challenge: home.challenge),
          const SizedBox(height: 24),
          _FeaturedSection(plans: home.featuredPlans),
          const SizedBox(height: 24),
          _ProgramsSection(state: state),
        ],
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.header});

  final HomeHeader header;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _HomeContent._gutter),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  header.date,
                  style: AppTextStyles.smallRegular
                      .copyWith(color: AppColors.greyscale400),
                ),
                const SizedBox(height: 4),
                Text(header.greeting, style: AppTextStyles.h6),
              ],
            ),
          ),
          NotificationButton(
            iconUrl: header.notificationIconUrl,
            hasUnread: header.hasUnreadNotifications,
            onTap: () => showAppMessage(
              context,
              header.hasUnreadNotifications
                  ? 'You have new notifications'
                  : 'No new notifications',
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({required this.challenge});

  final TodaysChallenge challenge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _HomeContent._gutter),
      child: GestureDetector(
        onTap: () => context.read<HomeCubit>().completeChallengeStep(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.greyscale900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.title.replaceAll("'", '’'),
                      style: AppTextStyles.smallRegular
                          .copyWith(color: AppColors.greyscale300),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      challenge.activity,
                      style: AppTextStyles.h6
                          .copyWith(color: AppColors.greyscale0),
                    ),
                  ],
                ),
              ),
              ProgressRing(value: challenge.completed, total: challenge.total),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturedSection extends StatelessWidget {
  const _FeaturedSection({required this.plans});

  final List<FeaturedPlan> plans;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _HomeContent._gutter),
          child: SectionHeader(
            title: 'Featured Plan',
            onSeeAll: plans.isEmpty ? null : () => openPlans(context, plans),
          ),
        ),
        const SizedBox(height: 16),
        if (plans.isEmpty)
          const SizedBox(
            height: FeaturedCard.height,
            child: MessageView.empty(message: 'No featured plans yet.'),
          )
        else
          SizedBox(
            height: FeaturedCard.height,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: _HomeContent._gutter),
              itemCount: plans.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (_, i) => FeaturedCard(
                plan: plans[i],
                onStart: () => openGymDetails(context),
              ),
            ),
          ),
      ],
    );
  }
}

class _ProgramsSection extends StatelessWidget {
  const _ProgramsSection({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final FitnessHome home = state.home!;
    final List<WorkoutProgram> programs = state.visiblePrograms;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _HomeContent._gutter),
          child: SectionHeader(
            title: 'Workout Programs',
            onSeeAll: () => openPrograms(
              context,
              home: home,
              filterId: state.selectedFilterId,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 30,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding:
                const EdgeInsets.symmetric(horizontal: _HomeContent._gutter),
            itemCount: home.filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final ProgramFilter filter = home.filters[i];
              return CategoryChip(
                label: filter.name,
                selected: filter.id == state.selectedFilterId,
                onTap: () =>
                    context.read<HomeCubit>().selectFilter(filter.id),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _HomeContent._gutter),
          child: programs.isEmpty
              ? SizedBox(
                  height: ProgramCard.height,
                  child: MessageView.empty(
                    title: 'No programs found',
                    message:
                        'There are no ${state.selectedFilter?.name ?? ''} programs yet.',
                  ),
                )
              : ProgramGrid(
                  programs: programs,
                  onTap: (_) => openGymDetails(context),
                ),
        ),
      ],
    );
  }
}
