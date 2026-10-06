import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/home_models.dart';
import '../../data/repositories/fitness_repository.dart';
import '../load_status.dart';
import 'home_state.dart';

/// Gestionează starea ecranului Home: încărcare, chip-uri, challenge.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repository) : super(const HomeState());

  final FitnessRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      final FitnessHome home = await _repository.loadHome();
      emit(HomeState(
        status: home.isEmpty ? LoadStatus.empty : LoadStatus.success,
        home: home,
        selectedFilterId: home.initialFilterId,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LoadStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void selectFilter(String filterId) {
    if (state.home == null || filterId == state.selectedFilterId) return;
    emit(state.copyWith(selectedFilterId: filterId));
  }

  /// O apăsare pe cardul „Today's Challenge” bifează încă un pas.
  void completeChallengeStep() {
    final FitnessHome? home = state.home;
    if (home == null) return;
    final TodaysChallenge c = home.challenge;
    if (c.completed >= c.total) return;
    emit(state.copyWith(
      home: FitnessHome(
        header: home.header,
        challenge: c.copyWith(completed: c.completed + 1),
        featuredPlans: home.featuredPlans,
        filters: home.filters,
        programs: home.programs,
      ),
    ));
  }
}
