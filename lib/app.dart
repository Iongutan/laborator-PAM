import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_text_styles.dart';
import 'domain/usecases/get_gym_details.dart';
import 'domain/usecases/get_home_feed.dart';
import 'injection_container.dart';
import 'presentation/cubits/favorites/favorites_cubit.dart';
import 'presentation/cubits/home/home_cubit.dart';
import 'presentation/screens/home_screen.dart';

/// Rădăcina aplicației: pune la dispoziție use case-urile și Cubit-urile globale.
class FitnessApp extends StatelessWidget {
  FitnessApp({super.key, AppDependencies? dependencies})
      : dependencies = dependencies ?? AppDependencies.create();

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GetHomeFeed>.value(value: dependencies.getHomeFeed),
        RepositoryProvider<GetGymDetails>.value(
            value: dependencies.getGymDetails),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                HomeCubit(context.read<GetHomeFeed>())..load(),
          ),
          BlocProvider(create: (_) => FavoritesCubit()),
        ],
        child: MaterialApp(
          title: 'Fitness',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: AppTextStyles.fontFamily,
            scaffoldBackgroundColor: AppColors.greyscale0,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary500,
              primary: AppColors.primary500,
              surface: AppColors.greyscale0,
            ),
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
