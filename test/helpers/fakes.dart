import 'dart:convert';
import 'dart:io';

import 'package:discount_calculator/core/error/failures.dart';
import 'package:discount_calculator/core/network/api_client.dart';
import 'package:discount_calculator/core/utils/result.dart';
import 'package:discount_calculator/data/models/gym_details_model.dart';
import 'package:discount_calculator/data/models/home_feed_model.dart';
import 'package:discount_calculator/domain/entities/gym_details.dart';
import 'package:discount_calculator/domain/entities/home_feed.dart';
import 'package:discount_calculator/domain/repositories/fitness_repository.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// Răspunsurile reale ale API-ului, salvate în test/fixtures.
String fixture(String name) => File('test/fixtures/$name').readAsStringSync();

Map<String, dynamic> fixtureJson(String name) =>
    jsonDecode(fixture(name)) as Map<String, dynamic>;

HomeFeed feedEntity() =>
    HomeFeedModel.fromJson(fixtureJson('feed.json')).toEntity();

GymDetails detailsEntity() =>
    GymDetailsModel.fromJson(fixtureJson('feed_details.json')).toEntity();

/// Un http.Client fals care răspunde ca serverul real
/// (/feed și /feed/details), fără internet.
MockClient fakeServer({
  int statusCode = 200,
  Duration delay = Duration.zero,
  void Function(http.Request request)? onRequest,
}) =>
    MockClient((request) async {
      onRequest?.call(request);
      if (delay > Duration.zero) await Future<void>.delayed(delay);
      final String path = request.url.path;
      final String? body = switch (path) {
        '/lab2026/v3/feed' => fixture('feed.json'),
        '/lab2026/v3/feed/details' => fixture('feed_details.json'),
        _ => null,
      };
      if (body == null) return http.Response('Not found', 404);
      return http.Response.bytes(utf8.encode(body), statusCode,
          headers: {'content-type': 'application/json'});
    });

ApiClient fakeApi(http.Client client) =>
    ApiClient(client: client, baseUrl: 'https://test.local');

/// Repository controlat din teste: date reale, eroare sau listă goală.
class FakeFitnessRepository implements FitnessRepository {
  FakeFitnessRepository({this.failure, this.empty = false});

  Failure? failure;
  final bool empty;
  int homeCalls = 0;

  @override
  Future<Result<HomeFeed>> getHomeFeed({bool forceRefresh = false}) async {
    homeCalls++;
    if (failure != null) return Failed(failure!);
    final HomeFeed feed = feedEntity();
    if (!empty) return Success(feed);
    return Success(HomeFeed(
      header: feed.header,
      challenge: feed.challenge,
      featuredPlans: const [],
      filters: feed.filters,
      programs: const [],
    ));
  }

  @override
  Future<Result<GymDetails>> getGymDetails({bool forceRefresh = false}) async {
    if (failure != null) return Failed(failure!);
    return Success(detailsEntity());
  }
}
