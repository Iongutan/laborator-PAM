import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/gym_details.dart';
import '../../domain/entities/home_feed.dart';
import '../../domain/repositories/fitness_repository.dart';
import '../datasources/fitness_remote_data_source.dart';

/// Implementarea repository-ului din Domain:
/// cere datele de la [FitnessRemoteDataSource], le transformă din modele în
/// entități și transformă excepțiile în [Failure]-uri.
/// Păstrează ultimul răspuns în memorie, ca navigarea să nu refacă cererea.
class FitnessRepositoryImpl implements FitnessRepository {
  FitnessRepositoryImpl(this._remote);

  final FitnessRemoteDataSource _remote;

  HomeFeed? _feedCache;
  GymDetails? _detailsCache;

  @override
  Future<Result<HomeFeed>> getHomeFeed({bool forceRefresh = false}) async {
    if (!forceRefresh && _feedCache != null) return Success(_feedCache!);
    return _guard(() async {
      final HomeFeed feed = (await _remote.fetchHomeFeed()).toEntity();
      return _feedCache = feed;
    });
  }

  @override
  Future<Result<GymDetails>> getGymDetails({bool forceRefresh = false}) async {
    if (!forceRefresh && _detailsCache != null) return Success(_detailsCache!);
    return _guard(() async {
      final GymDetails details = (await _remote.fetchGymDetails()).toEntity();
      return _detailsCache = details;
    });
  }

  /// Rulează cererea și traduce orice excepție într-un [Failure].
  Future<Result<T>> _guard<T>(Future<T> Function() request) async {
    try {
      return Success(await request());
    } on ServerException catch (e) {
      return Failed(ServerFailure(e.statusCode));
    } on RequestTimeoutException {
      return const Failed(TimeoutFailure());
    } on NetworkException {
      return const Failed(NetworkFailure());
    } on ParsingException {
      return const Failed(ParsingFailure());
    } on TypeError {
      // Un câmp are alt tip decât cel așteptat (ex: text în loc de număr).
      return const Failed(ParsingFailure());
    } on FormatException {
      return const Failed(ParsingFailure());
    }
  }
}
