import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_text_styles.dart';
import 'data/repositories/fitness_repository.dart';
import 'logic/favorites/favorites_cubit.dart';
import 'logic/home/home_cubit.dart';
import 'presentation/screens/home_screen.dart';

/// Rădăcina aplicației: injectează repository-ul și Cubit-urile globale.
class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key, this.repository});

  /// Se poate înlocui în teste (ex: un repository care dă eroare).
  final FitnessRepository? repository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<FitnessRepository>(
      create: (_) => repository ?? FitnessRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                HomeCubit(context.read<FitnessRepository>())..load(),
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
