import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/home_models.dart';
import 'program_query.dart';
import 'programs_state.dart';

/// Căutare, filtrare, sortare și „doar favorite” pe ecranul cu toate programele.
class ProgramsCubit extends Cubit<ProgramsState> {
  ProgramsCubit({
    required List<WorkoutProgram> programs,
    required List<ProgramFilter> filters,
    String initialFilterId = ProgramFilter.allId,
  }) : super(ProgramsState(
          programs: programs,
          filters: filters,
          selectedFilterId: initialFilterId,
        ));

  void search(String query) => emit(state.copyWith(query: query));

  void selectFilter(String filterId) =>
      emit(state.copyWith(selectedFilterId: filterId));

  void sortBy(ProgramSort sort) => emit(state.copyWith(sort: sort));

  void toggleFavoritesOnly() =>
      emit(state.copyWith(favoritesOnly: !state.favoritesOnly));

  void clear() => emit(state.copyWith(
        query: '',
        selectedFilterId: ProgramFilter.allId,
        sort: ProgramSort.recommended,
        favoritesOnly: false,
      ));
}
