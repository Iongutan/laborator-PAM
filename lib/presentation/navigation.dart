import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme/app_colors.dart';
import '../data/models/home_models.dart';
import '../data/repositories/fitness_repository.dart';
import '../logic/gym/gym_details_cubit.dart';
import '../logic/programs/programs_cubit.dart';
import 'screens/gym_details_screen.dart';
import 'screens/plans_screen.dart';
import 'screens/programs_screen.dart';

/// Navigarea între ecrane. Fiecare ecran primește Cubit-ul lui.

void openGymDetails(BuildContext context) {
  final FitnessRepository repository = context.read<FitnessRepository>();
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (_) => GymDetailsCubit(repository)..load(),
        child: const GymDetailsScreen(),
      ),
    ),
  );
}

void openPrograms(
  BuildContext context, {
  required FitnessHome home,
  required String filterId,
}) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (_) => ProgramsCubit(
          programs: home.programs,
          filters: home.filters,
          initialFilterId: filterId,
        ),
        child: const ProgramsScreen(),
      ),
    ),
  );
}

void openPlans(BuildContext context, List<FeaturedPlan> plans) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => PlansScreen(plans: plans)),
  );
}

void showAppMessage(BuildContext context, String text) {
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
