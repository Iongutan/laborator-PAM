import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/gym_models.dart';
import '../../data/repositories/fitness_repository.dart';
import '../load_status.dart';
import 'gym_details_state.dart';

/// Starea paginii de detalii: încărcare, „Read more”, rezervare.
class GymDetailsCubit extends Cubit<GymDetailsState> {
  GymDetailsCubit(this._repository) : super(const GymDetailsState());

  final FitnessRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      final GymDetails details = await _repository.loadGymDetails();
      emit(GymDetailsState(
        status: details.gym.amenities.isEmpty && details.gym.name.isEmpty
            ? LoadStatus.empty
            : LoadStatus.success,
        details: details,
        descriptionExpanded: details.gym.descriptionExpanded,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LoadStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void toggleDescription() =>
      emit(state.copyWith(descriptionExpanded: !state.descriptionExpanded));

  void toggleReservation() {
    final GymDetails? details = state.details;
    if (details == null || !details.actions.reserveEnabled) return;
    emit(state.copyWith(reserved: !state.reserved));
  }
}
