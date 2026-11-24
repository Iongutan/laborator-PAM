import '../../core/utils/result.dart';
import '../entities/gym_details.dart';
import '../repositories/fitness_repository.dart';

/// Use case: ia detaliile sălii (GET /feed/details).
class GetGymDetails {
  const GetGymDetails(this._repository);

  final FitnessRepository _repository;

  Future<Result<GymDetails>> call({bool forceRefresh = false}) =>
      _repository.getGymDetails(forceRefresh: forceRefresh);
}
