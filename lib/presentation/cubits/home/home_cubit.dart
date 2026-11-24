import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/home_feed.dart';
import '../../../domain/usecases/get_home_feed.dart';
import '../load_status.dart';
import 'home_state.dart';

/// Starea ecranului Home: încarcă feed-ul din API prin use case-ul
/// [GetHomeFeed], gestionează filtrul și progresul challenge-ului.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getHomeFeed) : super(const HomeState());

  final GetHomeFeed _getHomeFeed;

  Future<void> load({bool forceRefresh = false}) async {
    emit(state.copyWith(status: LoadStatus.loading));
    final result = await _getHomeFeed(forceRefresh: forceRefresh);
    if (isClosed) return;
    result.when(
      onSuccess: (feed) => emit(HomeState(
        status: feed.isEmpty ? LoadStatus.empty : LoadStatus.success,
        home: feed,
        selectedFilterId: feed.initialFilterId,
      )),
      onFailure: (failure) => emit(state.copyWith(
        status: LoadStatus.failure,
        errorMessage: failure.message,
      )),
    );
  }

  /// Reîncarcă de la server (tragere în jos / „Try again”).
  Future<void> refresh() => load(forceRefresh: true);

  void selectFilter(String filterId) {
    if (state.home == null || filterId == state.selectedFilterId) return;
    emit(state.copyWith(selectedFilterId: filterId));
  }

  /// O apăsare pe cardul „Today's Challenge” bifează încă un pas.
  void completeChallengeStep() {
    final HomeFeed? home = state.home;
    if (home == null) return;
    final TodaysChallenge c = home.challenge;
    if (c.completed >= c.total) return;
    emit(state.copyWith(
      home: home.copyWith(challenge: c.copyWith(completed: c.completed + 1)),
    ));
  }
}
