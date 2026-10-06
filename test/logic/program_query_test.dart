import 'package:discount_calculator/data/models/home_models.dart';
import 'package:discount_calculator/logic/programs/program_query.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';

void main() {
  final FitnessHome home = labHome();
  ProgramFilter filter(String id) => home.filters.firstWhere((f) => f.id == id);
  List<String> titles(List<WorkoutProgram> l) => l.map((p) => p.title).toList();

  test('filtrul „All Type” arată tot', () {
    expect(applyProgramQuery(home.programs, filter: filter('all')).length, 3);
  });

  test('filtrele după categorie', () {
    expect(titles(applyProgramQuery(home.programs, filter: filter('yoga'))),
        ['Yoga']);
    expect(titles(applyProgramQuery(home.programs, filter: filter('cardio'))),
        ['Cardio Training']);
    expect(applyProgramQuery(home.programs, filter: filter('boxing')), isEmpty);
  });

  test('căutarea nu ține cont de majuscule', () {
    expect(titles(applyProgramQuery(home.programs, query: 'ARM')),
        ['Arm Strengthening']);
    expect(applyProgramQuery(home.programs, query: 'zzz'), isEmpty);
  });

  test('sortările', () {
    expect(
        titles(applyProgramQuery(home.programs, sort: ProgramSort.nameAsc)),
        ['Arm Strengthening', 'Cardio Training', 'Yoga']);
    expect(
        titles(applyProgramQuery(home.programs, sort: ProgramSort.nameDesc)),
        ['Yoga', 'Cardio Training', 'Arm Strengthening']);
    expect(
        titles(
            applyProgramQuery(home.programs, sort: ProgramSort.caloriesDesc))
            .first,
        'Cardio Training');
    expect(
        titles(applyProgramQuery(home.programs, sort: ProgramSort.durationAsc))
            .first,
        'Cardio Training');
  });

  test('doar favorite', () {
    expect(titles(applyProgramQuery(home.programs, onlyIds: {'wp002'})),
        ['Arm Strengthening']);
  });
}
