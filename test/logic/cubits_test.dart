import 'package:bloc_test/bloc_test.dart';
import 'package:discount_calculator/logic/favorites/favorites_cubit.dart';
import 'package:discount_calculator/logic/gym/gym_details_cubit.dart';
import 'package:discount_calculator/logic/gym/gym_details_state.dart';
import 'package:discount_calculator/logic/home/home_cubit.dart';
import 'package:discount_calculator/logic/home/home_state.dart';
import 'package:discount_calculator/logic/load_status.dart';
import 'package:discount_calculator/logic/programs/program_query.dart';
import 'package:discount_calculator/logic/programs/programs_cubit.dart';
import 'package:discount_calculator/logic/programs/programs_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';

void main() {
  group('HomeCubit', () {
    blocTest<HomeCubit, HomeState>(
      'Loading → Success',
      build: () => HomeCubit(FakeFitnessRepository()),
      act: (c) => c.load(),
      expect: () => [
        isA<HomeState>().having((s) => s.status, 'status', LoadStatus.loading),
        isA<HomeState>()
            .having((s) => s.status, 'status', LoadStatus.success)
            .having((s) => s.visiblePrograms.length, 'programs', 3),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'Loading → Error',
      build: () => HomeCubit(FakeFitnessRepository(fail: true)),
      act: (c) => c.load(),
      expect: () => [
        isA<HomeState>().having((s) => s.status, 'status', LoadStatus.loading),
        isA<HomeState>()
            .having((s) => s.status, 'status', LoadStatus.failure)
            .having((s) => s.errorMessage, 'error', 'Network is down'),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'Loading → Empty',
      build: () => HomeCubit(FakeFitnessRepository(empty: true)),
      act: (c) => c.load(),
      skip: 1,
      expect: () => [
        isA<HomeState>().having((s) => s.status, 'status', LoadStatus.empty),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'filtru + challenge',
      build: () => HomeCubit(FakeFitnessRepository()),
      act: (c) async {
        await c.load();
        c.selectFilter('cardio');
        c.completeChallengeStep();
      },
      skip: 2,
      expect: () => [
        isA<HomeState>().having((s) => s.visiblePrograms.map((p) => p.title),
            'programs', ['Cardio Training']),
        isA<HomeState>()
            .having((s) => s.home!.challenge.completed, 'completed', 16),
      ],
    );
  });

  group('ProgramsCubit', () {
    final home = labHome();
    ProgramsCubit build() =>
        ProgramsCubit(programs: home.programs, filters: home.filters);

    blocTest<ProgramsCubit, ProgramsState>(
      'căutare, sortare, favorite, reset',
      build: build,
      act: (c) {
        c.search('a');
        c.sortBy(ProgramSort.nameDesc);
        c.toggleFavoritesOnly();
        c.clear();
      },
      expect: () => [
        isA<ProgramsState>().having((s) => s.query, 'query', 'a'),
        isA<ProgramsState>().having((s) => s.sort, 'sort', ProgramSort.nameDesc),
        isA<ProgramsState>()
            .having((s) => s.favoritesOnly, 'fav', true)
            .having((s) => s.visible({'wp001'}).length, 'visible', 1),
        isA<ProgramsState>()
            .having((s) => s.query, 'query', '')
            .having((s) => s.favoritesOnly, 'fav', false)
            .having((s) => s.visible(const {}).length, 'visible', 3),
      ],
    );
  });

  group('FavoritesCubit', () {
    blocTest<FavoritesCubit, Set<String>>(
      'adaugă și elimină',
      build: FavoritesCubit.new,
      act: (c) => c
        ..toggle('wp001')
        ..toggle('wp002')
        ..toggle('wp001'),
      expect: () => [
        {'wp001'},
        {'wp001', 'wp002'},
        {'wp002'},
      ],
    );
  });

  group('GymDetailsCubit', () {
    blocTest<GymDetailsCubit, GymDetailsState>(
      'încărcare, Read more, rezervare',
      build: () => GymDetailsCubit(FakeFitnessRepository()),
      act: (c) async {
        await c.load();
        c.toggleDescription();
        c.toggleReservation();
      },
      expect: () => [
        isA<GymDetailsState>()
            .having((s) => s.status, 'status', LoadStatus.loading),
        isA<GymDetailsState>()
            .having((s) => s.status, 'status', LoadStatus.success)
            .having((s) => s.details!.gym.amenities.length, 'amenities', 2),
        isA<GymDetailsState>()
            .having((s) => s.descriptionExpanded, 'expanded', true),
        isA<GymDetailsState>().having((s) => s.reserved, 'reserved', true),
      ],
    );

    blocTest<GymDetailsCubit, GymDetailsState>(
      'eroare',
      build: () => GymDetailsCubit(FakeFitnessRepository(fail: true)),
      act: (c) => c.load(),
      skip: 1,
      expect: () => [
        isA<GymDetailsState>()
            .having((s) => s.status, 'status', LoadStatus.failure),
      ],
    );
  });
}
