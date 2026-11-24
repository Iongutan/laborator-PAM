import 'package:equatable/equatable.dart';

// Entitățile paginii de detalii a sălii (domain).

class Amenity extends Equatable {
  const Amenity({required this.id, required this.name, required this.iconUrl});

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

  final Gym gym;
  final GymActions actions;

  @override
  List<Object?> get props => [gym, actions];
}
