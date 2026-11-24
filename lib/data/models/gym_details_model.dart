import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/gym_details.dart';

part 'gym_details_model.g.dart';

// Modelele (DTO) pentru răspunsul GET /lab2026/v3/feed/details.
// fromJson / toJson sunt generate de json_serializable în
// gym_details_model.g.dart; toEntity() dă entitatea din Domain.

@JsonSerializable(explicitToJson: true)
class GymDetailsModel {
  const GymDetailsModel({required this.gym, required this.actions});

  factory GymDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$GymDetailsModelFromJson(json);

  final GymModel gym;
  final GymActionsModel actions;

  Map<String, dynamic> toJson() => _$GymDetailsModelToJson(this);

  GymDetails toEntity() =>
      GymDetails(gym: gym.toEntity(), actions: actions.toEntity());
}

@JsonSerializable(explicitToJson: true)
class GymModel {
  const GymModel({
    required this.id,
    required this.name,
    required this.location,
    required this.heroImageUrl,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.descriptionExpanded,
    required this.amenities,
    required this.pricing,
  });

  factory GymModel.fromJson(Map<String, dynamic> json) =>
      _$GymModelFromJson(json);

  final String id;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String location;
  @JsonKey(defaultValue: '')
  final String heroImageUrl;
  @JsonKey(defaultValue: 0.0)
  final double rating;
  @JsonKey(defaultValue: 0)
  final int reviewCount;
  @JsonKey(defaultValue: '')
  final String description;
  @JsonKey(defaultValue: false)
  final bool descriptionExpanded;
  @JsonKey(defaultValue: <AmenityModel>[])
  final List<AmenityModel> amenities;
  final PricingModel pricing;

  Map<String, dynamic> toJson() => _$GymModelToJson(this);

  Gym toEntity() => Gym(
        id: id,
        name: name,
        location: location,
        heroImageUrl: heroImageUrl,
        rating: rating,
        reviewCount: reviewCount,
        description: description,
        descriptionExpanded: descriptionExpanded,
        amenities: amenities.map((a) => a.toEntity()).toList(),
        pricing: pricing.toEntity(),
      );
}

@JsonSerializable()
class AmenityModel {
  const AmenityModel({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  factory AmenityModel.fromJson(Map<String, dynamic> json) =>
      _$AmenityModelFromJson(json);

  final String id;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String iconUrl;

  Map<String, dynamic> toJson() => _$AmenityModelToJson(this);

  Amenity toEntity() => Amenity(id: id, name: name, iconUrl: iconUrl);
}

@JsonSerializable()
class PricingModel {
  const PricingModel({
    required this.amount,
    required this.currency,
    required this.period,
    required this.formatted,
  });

  factory PricingModel.fromJson(Map<String, dynamic> json) =>
      _$PricingModelFromJson(json);

  @JsonKey(defaultValue: 0.0)
  final double amount;
  @JsonKey(defaultValue: 'USD')
  final String currency;
  @JsonKey(defaultValue: 'week')
  final String period;
  @JsonKey(defaultValue: '')
  final String formatted;

  Map<String, dynamic> toJson() => _$PricingModelToJson(this);

  Pricing toEntity() => Pricing(
        amount: amount,
        currency: currency,
        period: period,
        formatted: formatted,
      );
}

@JsonSerializable(explicitToJson: true)
class GymActionsModel {
  const GymActionsModel({
    required this.backIconUrl,
    required this.moreIconUrl,
    required this.ratingIconUrl,
    required this.reserve,
  });

  factory GymActionsModel.fromJson(Map<String, dynamic> json) =>
      _$GymActionsModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String backIconUrl;
  @JsonKey(defaultValue: '')
  final String moreIconUrl;
  @JsonKey(defaultValue: '')
  final String ratingIconUrl;
  final ReserveModel reserve;

  Map<String, dynamic> toJson() => _$GymActionsModelToJson(this);

  GymActions toEntity() => GymActions(
        backIconUrl: backIconUrl,
        moreIconUrl: moreIconUrl,
        ratingIconUrl: ratingIconUrl,
        reserveLabel: reserve.label,
        reserveEnabled: reserve.enabled,
      );
}

@JsonSerializable()
class ReserveModel {
  const ReserveModel({required this.label, required this.enabled});

  factory ReserveModel.fromJson(Map<String, dynamic> json) =>
      _$ReserveModelFromJson(json);

  @JsonKey(defaultValue: 'Reserve')
  final String label;
  @JsonKey(defaultValue: true)
  final bool enabled;

  Map<String, dynamic> toJson() => _$ReserveModelToJson(this);
}
