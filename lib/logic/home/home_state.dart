import 'package:equatable/equatable.dart';

import '../../data/models/home_models.dart';
import '../load_status.dart';
import '../programs/program_query.dart';

class HomeState extends Equatable {
  const HomeState({
    this.status = LoadStatus.initial,
    this.home,
    this.selectedFilterId = ProgramFilter.allId,
    this.errorMessage,
  });

  final LoadStatus status;
  final FitnessHome? home;
  final String selectedFilterId;
  final String? errorMessage;

  ProgramFilter? get selectedFilter {
    final List<ProgramFilter> filters = home?.filters ?? const [];
    for (final ProgramFilter f in filters) {
      if (f.id == selectedFilterId) return f;
    }
    return null;
  }

  /// Programele afișate pe Home pentru chip-ul selectat.
  List<WorkoutProgram> get visiblePrograms => applyProgramQuery(
        home?.programs ?? const [],
        filter: selectedFilter,
      );

  HomeState copyWith({
    LoadStatus? status,
    FitnessHome? home,
    String? selectedFilterId,
    String? errorMessage,
  }) =>
      HomeState(
        status: status ?? this.status,
        home: home ?? this.home,
        selectedFilterId: selectedFilterId ?? this.selectedFilterId,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, home, selectedFilterId, errorMessage];
}
