import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/gym_details.dart';
import '../../../domain/usecases/get_gym_details.dart';
import '../load_status.dart';
import 'gym_details_state.dart';

/// Starea paginii de detalii: încarcă datele din API prin [GetGymDetails],
/// gestionează „Read more” și rezervarea.
class GymDetailsCubit extends Cubit<GymDetailsState> {
  GymDetailsCubit(this._getGymDetails) : super(const GymDetailsState());

  final GetGymDetails _getGymDetails;

  Future<void> load({bool forceRefresh = false}) async {
    emit(state.copyWith(status: LoadStatus.loading));
    final result = await _getGymDetails(forceRefresh: forceRefresh);
    if (isClosed) return;
    result.when(
      onSuccess: (details) => emit(GymDetailsState(
        status: details.gym.name.isEmpty && details.gym.amenities.isEmpty
            ? LoadStatus.empty
            : LoadStatus.success,
        details: details,
        descriptionExpanded: details.gym.descriptionExpanded,
      )),
      onFailure: (failure) => emit(state.copyWith(
        status: LoadStatus.failure,
        errorMessage: failure.message,
      )),
    );
  }

  Future<void> refresh() => load(forceRefresh: true);

  void toggleDescription() =>
      emit(state.copyWith(descriptionExpanded: !state.descriptionExpanded));

  void toggleReservation() {
    final GymDetails? details = state.details;
    if (details == null || !details.actions.reserveEnabled) return;
    emit(state.copyWith(reserved: !state.reserved));
  }
}
