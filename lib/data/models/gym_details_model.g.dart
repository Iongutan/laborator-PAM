// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gym_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GymDetailsModel _$GymDetailsModelFromJson(Map<String, dynamic> json) =>
    GymDetailsModel(
      gym: GymModel.fromJson(json['gym'] as Map<String, dynamic>),
      actions:
          GymActionsModel.fromJson(json['actions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GymDetailsModelToJson(GymDetailsModel instance) =>
    <String, dynamic>{
      'gym': instance.gym.toJson(),
      'actions': instance.actions.toJson(),
    };

GymModel _$GymModelFromJson(Map<String, dynamic> json) => GymModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      heroImageUrl: json['heroImageUrl'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      description: json['description'] as String? ?? '',
      descriptionExpanded: json['descriptionExpanded'] as bool? ?? false,
      amenities: (json['amenities'] as List<dynamic>?)
              ?.map((e) => AmenityModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pricing: PricingModel.fromJson(json['pricing'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GymModelToJson(GymModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'heroImageUrl': instance.heroImageUrl,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'description': instance.description,
      'descriptionExpanded': instance.descriptionExpanded,
      'amenities': instance.amenities.map((e) => e.toJson()).toList(),
      'pricing': instance.pricing.toJson(),
    };

AmenityModel _$AmenityModelFromJson(Map<String, dynamic> json) => AmenityModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      iconUrl: json['iconUrl'] as String? ?? '',
    );

Map<String, dynamic> _$AmenityModelToJson(AmenityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'iconUrl': instance.iconUrl,
    };

PricingModel _$PricingModelFromJson(Map<String, dynamic> json) => PricingModel(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'USD',
      period: json['period'] as String? ?? 'week',
      formatted: json['formatted'] as String? ?? '',
    );

Map<String, dynamic> _$PricingModelToJson(PricingModel instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'currency': instance.currency,
      'period': instance.period,
      'formatted': instance.formatted,
    };

GymActionsModel _$GymActionsModelFromJson(Map<String, dynamic> json) =>
    GymActionsModel(
      backIconUrl: json['backIconUrl'] as String? ?? '',
      moreIconUrl: json['moreIconUrl'] as String? ?? '',
      ratingIconUrl: json['ratingIconUrl'] as String? ?? '',
      reserve: ReserveModel.fromJson(json['reserve'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GymActionsModelToJson(GymActionsModel instance) =>
    <String, dynamic>{
      'backIconUrl': instance.backIconUrl,
      'moreIconUrl': instance.moreIconUrl,
      'ratingIconUrl': instance.ratingIconUrl,
      'reserve': instance.reserve.toJson(),
    };

ReserveModel _$ReserveModelFromJson(Map<String, dynamic> json) => ReserveModel(
      label: json['label'] as String? ?? 'Reserve',
      enabled: json['enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$ReserveModelToJson(ReserveModel instance) =>
    <String, dynamic>{
      'label': instance.label,
      'enabled': instance.enabled,
    };
