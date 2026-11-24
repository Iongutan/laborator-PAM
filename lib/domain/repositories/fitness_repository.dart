import '../../core/utils/result.dart';
import '../entities/gym_details.dart';
import '../entities/home_feed.dart';

/// Contractul stratului Domain. Implementarea (cu HTTP) e în stratul Data,
/// așa că Domain și Presentation nu depind de API.
abstract interface class FitnessRepository {
  Future<Result<HomeFeed>> getHomeFeed({bool forceRefresh = false});

  Future<Result<GymDetails>> getGymDetails({bool forceRefresh = false});
}
