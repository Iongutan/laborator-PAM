import '../../data/models/home_models.dart';

/// Opțiunile de sortare pentru lista de programe.
enum ProgramSort {
  recommended('Recommended'),
  nameAsc('Name (A–Z)'),
  nameDesc('Name (Z–A)'),
  caloriesDesc('Calories (high → low)'),
  durationAsc('Duration (short → long)');

  const ProgramSort(this.label);

  final String label;
}

/// Aplică filtrul, căutarea, „doar favorite” și sortarea asupra programelor.
/// Funcție pură — o folosesc atât HomeCubit, cât și ProgramsCubit.
List<WorkoutProgram> applyProgramQuery(
  List<WorkoutProgram> programs, {
  ProgramFilter? filter,
  String query = '',
  ProgramSort sort = ProgramSort.recommended,
  Set<String>? onlyIds,
}) {
  final String q = query.trim().toLowerCase();
  final List<WorkoutProgram> result = programs.where((p) {
    if (filter != null && !p.matchesFilter(filter)) return false;
    if (onlyIds != null && !onlyIds.contains(p.id)) return false;
    if (q.isNotEmpty && !p.title.toLowerCase().contains(q)) return false;
    return true;
  }).toList();

  switch (sort) {
    case ProgramSort.recommended:
      break;
    case ProgramSort.nameAsc:
      result.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    case ProgramSort.nameDesc:
      result.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
    case ProgramSort.caloriesDesc:
      result.sort((a, b) => b.calories.compareTo(a.calories));
    case ProgramSort.durationAsc:
      result.sort((a, b) => a.durationMinutes.compareTo(b.durationMinutes));
  }
  return result;
}
