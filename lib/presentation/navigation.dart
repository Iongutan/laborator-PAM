import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme/app_colors.dart';
import '../domain/entities/home_feed.dart';
import '../domain/usecases/get_gym_details.dart';
import 'cubits/gym/gym_details_cubit.dart';
import 'cubits/programs/programs_cubit.dart';
import 'screens/gym_details_screen.dart';
import 'screens/plans_screen.dart';
import 'screens/programs_screen.dart';

/// Navigarea între ecrane. Fiecare ecran primește Cubit-ul lui.

void openGymDetails(BuildContext context) {
  final GetGymDetails getGymDetails = context.read<GetGymDetails>();
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (_) => GymDetailsCubit(getGymDetails)..load(),
        child: const GymDetailsScreen(),
      ),
    ),
  );
}

void openPrograms(
  BuildContext context, {
  required HomeFeed home,
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
