import 'package:discount_calculator/data/models/gym_details_model.dart';
import 'package:discount_calculator/data/models/home_feed_model.dart';
import 'package:discount_calculator/domain/entities/home_feed.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';

void main() {
  group('HomeFeedModel (GET /feed)', () {
    test('fromJson + toEntity', () {
      final HomeFeed feed =
          HomeFeedModel.fromJson(fixtureJson('feed.json')).toEntity();

      expect(feed.header.date, 'Friday, 20 May');
      expect(feed.header.greeting, 'Good Morning');
      expect(feed.header.hasUnreadNotifications, isTrue);
      expect(feed.challenge.activity, 'Running');
      expect(feed.challenge.completed, 15);
      expect(feed.challenge.total, 20);
      expect(feed.challenge.progress, 0.75);
      expect(feed.featuredPlans.map((p) => p.title),
          ['Massive Upper Body', 'Strong & Fit']);
      expect(feed.featuredPlans.first.durationIconUrl, contains('calendar'));
      expect(feed.filters.map((f) => f.id),
          ['all', 'pilates', 'cardio', 'boxing', 'yoga']);
      expect(feed.filters.first.iconUrl, contains('view-grid'));
      expect(feed.initialFilterId, 'all');
      expect(feed.programs.map((p) => p.title),
          ['Yoga', 'Arm Strengthening', 'Cardio Training']);
      expect(feed.programs[1].isPro, isTrue);
      expect(feed.programs[1].proIconUrl, isNotNull);
      expect(feed.programs[0].proIconUrl, isNull);
    });

    test('toJson → fromJson dă același rezultat (serializare dus-întors)', () {
      final HomeFeedModel model = HomeFeedModel.fromJson(fixtureJson('feed.json'));
      final HomeFeedModel again = HomeFeedModel.fromJson(model.toJson());
      expect(again.toEntity(), model.toEntity());
    });

    test('câmpurile lipsă primesc valori implicite', () {
      final ProgramModel p = ProgramModel.fromJson(const {
        'id': 'x',
        'icons': <String, dynamic>{},
      });
      expect(p.title, '');
      expect(p.calories, 0);
      expect(p.isPro, isFalse);
      expect(p.icons.proIconUrl, isNull);
    });
  });

  group('GymDetailsModel (GET /feed/details)', () {
    test('fromJson + toEntity', () {
      final details =
          GymDetailsModel.fromJson(fixtureJson('feed_details.json')).toEntity();

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

    test('toJson → fromJson', () {
      final GymDetailsModel model =
          GymDetailsModel.fromJson(fixtureJson('feed_details.json'));
      expect(GymDetailsModel.fromJson(model.toJson()).toEntity(),
          model.toEntity());
    });
  });
}
