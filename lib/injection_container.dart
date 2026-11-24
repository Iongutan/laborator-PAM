import 'core/network/api_client.dart';
import 'data/datasources/fitness_remote_data_source.dart';
import 'data/repositories/fitness_repository_impl.dart';
import 'domain/repositories/fitness_repository.dart';
import 'domain/usecases/get_gym_details.dart';
import 'domain/usecases/get_home_feed.dart';

/// Leagă straturile între ele (dependency injection manual):
/// ApiClient → RemoteDataSource → RepositoryImpl → UseCases.
/// Presentation primește doar use case-urile.
class AppDependencies {
  AppDependencies._(this.repository)
      : getHomeFeed = GetHomeFeed(repository),
        getGymDetails = GetGymDetails(repository);

  /// Dependențele reale, care vorbesc cu serviciul Web.
  factory AppDependencies.create() {
    final ApiClient api = ApiClient();
    final FitnessRemoteDataSource remote = FitnessRemoteDataSourceImpl(api);
    return AppDependencies._(FitnessRepositoryImpl(remote));
  }

  /// Pentru teste: orice implementare a repository-ului.
  factory AppDependencies.withRepository(FitnessRepository repository) =>
      AppDependencies._(repository);

  final FitnessRepository repository;
  final GetHomeFeed getHomeFeed;
  final GetGymDetails getGymDetails;
}
