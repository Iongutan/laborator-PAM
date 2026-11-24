import '../../core/utils/result.dart';
import '../entities/home_feed.dart';
import '../repositories/fitness_repository.dart';

/// Use case: ia datele paginii Home (GET /feed).
class GetHomeFeed {
  const GetHomeFeed(this._repository);

  final FitnessRepository _repository;

  Future<Result<HomeFeed>> call({bool forceRefresh = false}) =>
      _repository.getHomeFeed(forceRefresh: forceRefresh);
}
