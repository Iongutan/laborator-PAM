import 'package:equatable/equatable.dart';

// Modelele pentru a doua pagină (fitnessGymDetailsPage din lab_v3.json).

class Amenity extends Equatable {
  const Amenity({required this.id, required this.name, required this.iconUrl});

  factory Amenity.fromJson(Map<String, dynamic> json) => Amenity(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        iconUrl: json['iconUrl'] as String? ?? '',
      );

  final String id;
  final String name;
  final String iconUrl;

  @override
  List<Object?> get props => [id, name, iconUrl];
}

class Pricing extends Equatable {
  const Pricing({
    required this.amount,
    required this.currency,
    required this.period,
    required this.formatted,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) => Pricing(
        amount: (json['amount'] as num?)?.toDouble() ?? 0,
        currency: json['currency'] as String? ?? 'USD',
        period: json['period'] as String? ?? 'week',
        formatted: json['formatted'] as String? ?? '',
      );

  final double amount;
  final String currency;
  final String period;
  final String formatted;

  /// „$69.00” — partea îngroșată din bara de jos.
  String get amountLabel =>
      '${currency == 'USD' ? '\$' : '$currency '}${amount.toStringAsFixed(2)}';

  @override
  List<Object?> get props => [amount, currency, period, formatted];
}

class Gym extends Equatable {
  const Gym({
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

  factory Gym.fromJson(Map<String, dynamic> json) => Gym(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        location: json['location'] as String? ?? '',
        heroImageUrl: json['heroImageUrl'] as String? ?? '',
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
        description: json['description'] as String? ?? '',
        descriptionExpanded: json['descriptionExpanded'] as bool? ?? false,
        amenities: (json['amenities'] as List<dynamic>? ?? const [])
            .map((e) => Amenity.fromJson(e as Map<String, dynamic>))
            .toList(),
        pricing: Pricing.fromJson(
            json['pricing'] as Map<String, dynamic>? ?? const {}),
      );

  final String id;
  final String name;
  final String location;
  final String heroImageUrl;
  final double rating;
  final int reviewCount;
  final String description;
  final bool descriptionExpanded;
  final List<Amenity> amenities;
  final Pricing pricing;

  @override
  List<Object?> get props => [
        id,
        name,
        location,
        heroImageUrl,
        rating,
        reviewCount,
        description,
        descriptionExpanded,
        amenities,
        pricing,
      ];
}

class GymActions extends Equatable {
  const GymActions({
    required this.backIconUrl,
    required this.moreIconUrl,
    required this.ratingIconUrl,
    required this.reserveLabel,
    required this.reserveEnabled,
  });

  factory GymActions.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> reserve =
        json['reserve'] as Map<String, dynamic>? ?? const {};
    return GymActions(
      backIconUrl: json['backIconUrl'] as String? ?? '',
      moreIconUrl: json['moreIconUrl'] as String? ?? '',
      ratingIconUrl: json['ratingIconUrl'] as String? ?? '',
      reserveLabel: reserve['label'] as String? ?? 'Reserve',
      reserveEnabled: reserve['enabled'] as bool? ?? true,
    );
  }

  final String backIconUrl;
  final String moreIconUrl;
  final String ratingIconUrl;
  final String reserveLabel;
  final bool reserveEnabled;

  @override
  List<Object?> get props =>
      [backIconUrl, moreIconUrl, ratingIconUrl, reserveLabel, reserveEnabled];
}

class GymDetails extends Equatable {
  const GymDetails({required this.gym, required this.actions});

  factory GymDetails.fromJson(Map<String, dynamic> json) => GymDetails(
        gym: Gym.fromJson(json['gym'] as Map<String, dynamic>),
        actions: GymActions.fromJson(
            json['actions'] as Map<String, dynamic>? ?? const {}),
      );

  final Gym gym;
  final GymActions actions;

  @override
  List<Object?> get props => [gym, actions];
}
