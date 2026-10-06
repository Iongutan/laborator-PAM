import 'package:equatable/equatable.dart';

import '../../data/models/home_models.dart';
import 'program_query.dart';

class ProgramsState extends Equatable {
  const ProgramsState({
    required this.programs,
    required this.filters,
    required this.selectedFilterId,
    this.query = '',
    this.sort = ProgramSort.recommended,
    this.favoritesOnly = false,
  });

  final List<WorkoutProgram> programs;
  final List<ProgramFilter> filters;
  final String selectedFilterId;
  final String query;
  final ProgramSort sort;
  final bool favoritesOnly;

  ProgramFilter? get selectedFilter {
    for (final ProgramFilter f in filters) {
      if (f.id == selectedFilterId) return f;
    }
    return null;
  }

  /// Rezultatul final, după filtru, căutare, favorite și sortare.
  List<WorkoutProgram> visible(Set<String> favoriteIds) => applyProgramQuery(
        programs,
        filter: selectedFilter,
        query: query,
        sort: sort,
        onlyIds: favoritesOnly ? favoriteIds : null,
      );

  ProgramsState copyWith({
    String? selectedFilterId,
    String? query,
    ProgramSort? sort,
    bool? favoritesOnly,
  }) =>
      ProgramsState(
        programs: programs,
        filters: filters,
        selectedFilterId: selectedFilterId ?? this.selectedFilterId,
        query: query ?? this.query,
        sort: sort ?? this.sort,
        favoritesOnly: favoritesOnly ?? this.favoritesOnly,
      );

  @override
  List<Object?> get props =>
      [programs, filters, selectedFilterId, query, sort, favoritesOnly];
}
