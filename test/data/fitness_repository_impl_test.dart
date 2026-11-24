import 'package:discount_calculator/core/error/failures.dart';
import 'package:discount_calculator/core/utils/result.dart';
import 'package:discount_calculator/data/datasources/fitness_remote_data_source.dart';
import 'package:discount_calculator/data/repositories/fitness_repository_impl.dart';
import 'package:discount_calculator/domain/entities/home_feed.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../helpers/fakes.dart';

FitnessRepositoryImpl repoWith(http.Client client) =>
    FitnessRepositoryImpl(FitnessRemoteDataSourceImpl(fakeApi(client)));

void main() {
  test('Success cu entitatea HomeFeed', () async {
    final Result<HomeFeed> result = await repoWith(fakeServer()).getHomeFeed();
    expect(result, isA<Success<HomeFeed>>());
    expect((result as Success<HomeFeed>).data.programs.length, 3);
  });

  test('Success cu GymDetails', () async {
    final result = await repoWith(fakeServer()).getGymDetails();
    expect(result.when(onSuccess: (d) => d.gym.name, onFailure: (_) => ''),
        'Mid City Gym Training');
  });

  test('erorile devin Failure-uri', () async {
    Future<Failure?> failureOf(http.Client c) async =>
        (await repoWith(c).getHomeFeed())
            .when(onSuccess: (_) => null, onFailure: (f) => f);

    expect(await failureOf(fakeServer(statusCode: 503)),
        const ServerFailure(503));
    expect(await failureOf(MockClient((_) async => throw http.ClientException('x'))),
        const NetworkFailure());
    expect(await failureOf(MockClient((_) async => http.Response('nu e json', 200))),
        const ParsingFailure());
    expect(
        await failureOf(MockClient(
            (_) async => http.Response('{"header": "wrong"}', 200))),
        const ParsingFailure());
  });

  test('al doilea apel vine din cache; forceRefresh cere din nou', () async {
    int calls = 0;
    final FitnessRepositoryImpl repo =
        repoWith(fakeServer(onRequest: (_) => calls++));

    await repo.getHomeFeed();
    await repo.getHomeFeed();
    expect(calls, 1);

    await repo.getHomeFeed(forceRefresh: true);
    expect(calls, 2);
  });
}
