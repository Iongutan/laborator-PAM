import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/gym_details_model.dart';
import '../models/home_feed_model.dart';

/// Sursa de date remote: apelează serviciul Web REST și deserializează
/// JSON-ul în modele. Aruncă excepțiile din core/error/exceptions.dart.
abstract interface class FitnessRemoteDataSource {
  /// GET /lab2026/v3/feed
  Future<HomeFeedModel> fetchHomeFeed();

  /// GET /lab2026/v3/feed/details
  Future<GymDetailsModel> fetchGymDetails();
}

class FitnessRemoteDataSourceImpl implements FitnessRemoteDataSource {
  const FitnessRemoteDataSourceImpl(this._api);

  final ApiClient _api;

  @override
  Future<HomeFeedModel> fetchHomeFeed() async =>
      HomeFeedModel.fromJson(await _api.getJson(ApiConstants.feedPath));

  @override
  Future<GymDetailsModel> fetchGymDetails() async => GymDetailsModel.fromJson(
      await _api.getJson(ApiConstants.feedDetailsPath));
}
