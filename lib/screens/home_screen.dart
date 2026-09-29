import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/fitness_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/category_chip.dart';
import '../widgets/featured_card.dart';
import '../widgets/program_card.dart';
import '../widgets/progress_ring.dart';
import '../widgets/section_header.dart';
import 'gym_detail_screen.dart';

/// Ecranul „21. Home v2” din Figma.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const double _gutter = 24;

  String _selectedCategory = workoutCategories.first;
  int _challengeDone = 15;
  final int _challengeTotal = 20;

  List<WorkoutProgram> get _visiblePrograms => _selectedCategory == 'All Type'
      ? workoutPrograms
      : workoutPrograms
          .where((p) => p.categories.contains(_selectedCategory))
          .toList();

  void _openGym() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const GymDetailScreen(gym: midCityGym),
      ),
    );
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.greyscale900,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.greyscale0,
        body: SafeArea(
          bottom: false,
          child: ListView(
            padding: const EdgeInsets.only(top: 16, bottom: 17),
            children: [
              _buildGreeting(),
              const SizedBox(height: 29),
              _buildChallenge(),
              const SizedBox(height: 24),
              _buildFeatured(),
              const SizedBox(height: 24),
              _buildPrograms(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    final DateTime now = DateTime.now();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _gutter),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatDate(now),
                  style: AppTextStyles.smallRegular
                      .copyWith(color: AppColors.greyscale400),
                ),
                const SizedBox(height: 4),
                Text(greetingFor(now), style: AppTextStyles.h6),
              ],
            ),
          ),
          Semantics(
            button: true,
            label: 'Notifications',
            child: GestureDetector(
              onTap: () => _showMessage('You have 1 new notification'),
              child: SvgPicture.asset(AppIcons.bellButton,
                  width: 48, height: 48),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallenge() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _gutter),
      child: GestureDetector(
        onTap: () {
          if (_challengeDone < _challengeTotal) {
            setState(() => _challengeDone++);
          }
        },
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
                      'Today’s Challenge',
                      style: AppTextStyles.smallRegular
                          .copyWith(color: AppColors.greyscale300),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Running',
                      style: AppTextStyles.h6
                          .copyWith(color: AppColors.greyscale0),
                    ),
                  ],
                ),
              ),
              ProgressRing(value: _challengeDone, total: _challengeTotal),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatured() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _gutter),
          child: SectionHeader(
            title: 'Featured Plan',
            onSeeAll: () => _showMessage('All featured plans'),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: FeaturedCard.height,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: _gutter),
            itemCount: featuredPlans.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (_, i) =>
                FeaturedCard(plan: featuredPlans[i], onStart: _openGym),
          ),
        ),
      ],
    );
  }

  Widget _buildPrograms() {
    final List<WorkoutProgram> programs = _visiblePrograms;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _gutter),
          child: SectionHeader(
            title: 'Workout Programs',
            onSeeAll: () =>
                setState(() => _selectedCategory = workoutCategories.first),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 30,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: _gutter),
            itemCount: workoutCategories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final String category = workoutCategories[i];
              return CategoryChip(
                label: category,
                selected: category == _selectedCategory,
                onTap: () => setState(() => _selectedCategory = category),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _gutter),
          child: programs.isEmpty
              ? SizedBox(
                  height: 184,
                  child: Center(
                    child: Text(
                      'No programs in this category yet',
                      style: AppTextStyles.smallRegular
                          .copyWith(color: AppColors.greyscale400),
                    ),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: programs.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 184,
                  ),
                  itemBuilder: (_, i) =>
                      ProgramCard(program: programs[i], onTap: _openGym),
                ),
        ),
      ],
    );
  }
}

const List<String> _weekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const List<String> _months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// Formatează data ca în design: „Friday, 20 May”.
String formatDate(DateTime date) =>
    '${_weekdays[date.weekday - 1]}, ${date.day} ${_months[date.month - 1]}';

/// Salutul se schimbă în funcție de ora zilei.
String greetingFor(DateTime date) {
  if (date.hour < 12) return 'Good Morning';
  if (date.hour < 18) return 'Good Afternoon';
  return 'Good Evening';
}
