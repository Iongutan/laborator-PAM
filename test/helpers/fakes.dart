import 'dart:convert';
import 'dart:io';

import 'package:discount_calculator/data/models/gym_models.dart';
import 'package:discount_calculator/data/models/home_models.dart';
import 'package:discount_calculator/data/repositories/fitness_repository.dart';

/// JSON-ul real al laboratorului, citit direct de pe disc.
Map<String, dynamic> readLabJson() =>
    jsonDecode(File('assets/data/lab_v3.json').readAsStringSync())
        as Map<String, dynamic>;

FitnessHome labHome() => FitnessHome.fromJson(
    readLabJson()['fitnessHomePage'] as Map<String, dynamic>);

GymDetails labGym() => GymDetails.fromJson(
    readLabJson()['fitnessGymDetailsPage'] as Map<String, dynamic>);

/// Repository controlat din teste: date fixe, eroare sau listă goală.
class FakeFitnessRepository extends FitnessRepository {
  FakeFitnessRepository({this.fail = false, this.empty = false})
      : super(latency: Duration.zero);

  bool fail;
  final bool empty;
  int homeCalls = 0;

  @override
  Future<FitnessHome> loadHome() async {
    homeCalls++;
    if (fail) throw const FitnessDataException('Network is down');
    final FitnessHome home = labHome();
    if (!empty) return home;
    return FitnessHome(
      header: home.header,
      challenge: home.challenge,
      featuredPlans: const [],
      filters: home.filters,
      programs: const [],
    );
  }

  @override
  Future<GymDetails> loadGymDetails() async {
    if (fail) throw const FitnessDataException('Network is down');
    return labGym();
  }
}
