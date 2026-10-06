import 'package:discount_calculator/data/models/home_models.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';

void main() {
  test('FitnessHome citește corect lab_v3.json', () {
    final FitnessHome home = labHome();

    expect(home.header.date, 'Friday, 20 May');
    expect(home.header.greeting, 'Good Morning');
    expect(home.header.hasUnreadNotifications, isTrue);
    expect(home.challenge.activity, 'Running');
    expect(home.challenge.completed, 15);
    expect(home.challenge.total, 20);
    expect(home.challenge.progress, 0.75);
    expect(home.featuredPlans.map((p) => p.title),
        ['Massive Upper Body', 'Strong & Fit']);
    expect(home.filters.map((f) => f.id),
        ['all', 'pilates', 'cardio', 'boxing', 'yoga']);
    expect(home.initialFilterId, 'all');
    expect(home.programs.map((p) => p.title),
        ['Yoga', 'Arm Strengthening', 'Cardio Training']);
    expect(home.programs[1].isPro, isTrue);
    expect(home.programs[1].proIconUrl, isNotNull);
  });

  test('GymDetails citește corect a doua pagină', () {
    final details = labGym();

    expect(details.gym.name, 'Mid City Gym Training');
    expect(details.gym.location, 'California, New York');
    expect(details.gym.rating, 4.5);
    expect(details.gym.reviewCount, 1232);
    expect(details.gym.amenities.map((a) => a.name), ['Showers', 'Lockers']);
    expect(details.gym.pricing.amountLabel, '\$69.00');
    expect(details.gym.pricing.period, 'week');
    expect(details.actions.reserveLabel, 'Reserve');
    expect(details.actions.reserveEnabled, isTrue);
  });

  test('Câmpurile lipsă primesc valori implicite', () {
    final WorkoutProgram p = WorkoutProgram.fromJson(const {'id': 'x'});
    expect(p.title, '');
    expect(p.calories, 0);
    expect(p.isPro, isFalse);
  });
}
