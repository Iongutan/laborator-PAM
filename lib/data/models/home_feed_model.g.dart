// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_feed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeFeedModel _$HomeFeedModelFromJson(Map<String, dynamic> json) =>
    HomeFeedModel(
      header: HeaderModel.fromJson(json['header'] as Map<String, dynamic>),
      todaysChallenge: ChallengeModel.fromJson(
          json['todaysChallenge'] as Map<String, dynamic>),
      featuredPlans: (json['featuredPlans'] as List<dynamic>?)
              ?.map(
                  (e) => FeaturedPlanModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      workoutPrograms: WorkoutProgramsModel.fromJson(
          json['workoutPrograms'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HomeFeedModelToJson(HomeFeedModel instance) =>
    <String, dynamic>{
      'header': instance.header.toJson(),
      'todaysChallenge': instance.todaysChallenge.toJson(),
      'featuredPlans': instance.featuredPlans.map((e) => e.toJson()).toList(),
      'workoutPrograms': instance.workoutPrograms.toJson(),
    };

HeaderModel _$HeaderModelFromJson(Map<String, dynamic> json) => HeaderModel(
      date: json['date'] as String? ?? '',
      greeting: json['greeting'] as String? ?? '',
      notification: NotificationModel.fromJson(
          json['notification'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HeaderModelToJson(HeaderModel instance) =>
    <String, dynamic>{
      'date': instance.date,
      'greeting': instance.greeting,
      'notification': instance.notification.toJson(),
    };

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      hasUnread: json['hasUnread'] as bool? ?? false,
      iconUrl: json['iconUrl'] as String? ?? '',
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'hasUnread': instance.hasUnread,
      'iconUrl': instance.iconUrl,
    };

ChallengeModel _$ChallengeModelFromJson(Map<String, dynamic> json) =>
    ChallengeModel(
      title: json['title'] as String? ?? '',
      activity: json['activity'] as String? ?? '',
      completed: (json['completed'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      iconUrl: json['iconUrl'] as String? ?? '',
    );

Map<String, dynamic> _$ChallengeModelToJson(ChallengeModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'activity': instance.activity,
      'completed': instance.completed,
      'total': instance.total,
      'progress': instance.progress,
      'iconUrl': instance.iconUrl,
    };

FeaturedPlanModel _$FeaturedPlanModelFromJson(Map<String, dynamic> json) =>
    FeaturedPlanModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      frequency: json['frequency'] as String? ?? '',
      actionLabel: json['actionLabel'] as String? ?? 'Start Now',
      imageUrl: json['imageUrl'] as String? ?? '',
      metaIcons:
          MetaIconsModel.fromJson(json['metaIcons'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FeaturedPlanModelToJson(FeaturedPlanModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'duration': instance.duration,
      'frequency': instance.frequency,
      'actionLabel': instance.actionLabel,
      'imageUrl': instance.imageUrl,
      'metaIcons': instance.metaIcons.toJson(),
    };

MetaIconsModel _$MetaIconsModelFromJson(Map<String, dynamic> json) =>
    MetaIconsModel(
      durationIconUrl: json['durationIconUrl'] as String? ?? '',
      frequencyIconUrl: json['frequencyIconUrl'] as String? ?? '',
    );

Map<String, dynamic> _$MetaIconsModelToJson(MetaIconsModel instance) =>
    <String, dynamic>{
      'durationIconUrl': instance.durationIconUrl,
      'frequencyIconUrl': instance.frequencyIconUrl,
    };

WorkoutProgramsModel _$WorkoutProgramsModelFromJson(
        Map<String, dynamic> json) =>
    WorkoutProgramsModel(
      filters: (json['filters'] as List<dynamic>?)
              ?.map((e) => FilterModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      filterIconUrls: (json['filterIconUrls'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          {},
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ProgramModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$WorkoutProgramsModelToJson(
        WorkoutProgramsModel instance) =>
    <String, dynamic>{
      'filters': instance.filters.map((e) => e.toJson()).toList(),
      'filterIconUrls': instance.filterIconUrls,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

FilterModel _$FilterModelFromJson(Map<String, dynamic> json) => FilterModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      selected: json['selected'] as bool? ?? false,
    );

Map<String, dynamic> _$FilterModelToJson(FilterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'selected': instance.selected,
    };

ProgramModel _$ProgramModelFromJson(Map<String, dynamic> json) => ProgramModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      isPro: json['isPro'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String? ?? '',
      icons: ProgramIconsModel.fromJson(json['icons'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProgramModelToJson(ProgramModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'calories': instance.calories,
      'durationMinutes': instance.durationMinutes,
      'isPro': instance.isPro,
      'imageUrl': instance.imageUrl,
      'icons': instance.icons.toJson(),
    };

ProgramIconsModel _$ProgramIconsModelFromJson(Map<String, dynamic> json) =>
    ProgramIconsModel(
      caloriesIconUrl: json['caloriesIconUrl'] as String? ?? '',
      durationIconUrl: json['durationIconUrl'] as String? ?? '',
      proIconUrl: json['proIconUrl'] as String?,
    );

Map<String, dynamic> _$ProgramIconsModelToJson(ProgramIconsModel instance) =>
    <String, dynamic>{
      'caloriesIconUrl': instance.caloriesIconUrl,
      'durationIconUrl': instance.durationIconUrl,
      'proIconUrl': instance.proIconUrl,
    };
