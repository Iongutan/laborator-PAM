import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/home_feed.dart';

part 'home_feed_model.g.dart';

// Modelele (DTO) pentru răspunsul GET /lab2026/v3/feed.
// Structura lor copiază exact JSON-ul primit de la server; codul de
// serializare / deserializare (fromJson / toJson) e generat de
// json_serializable în home_feed_model.g.dart.
// Metoda toEntity() transformă modelul în entitatea din Domain.

@JsonSerializable(explicitToJson: true)
class HomeFeedModel {
  const HomeFeedModel({
    required this.header,
    required this.todaysChallenge,
    required this.featuredPlans,
    required this.workoutPrograms,
  });

  factory HomeFeedModel.fromJson(Map<String, dynamic> json) =>
      _$HomeFeedModelFromJson(json);

  final HeaderModel header;
  final ChallengeModel todaysChallenge;
  @JsonKey(defaultValue: <FeaturedPlanModel>[])
  final List<FeaturedPlanModel> featuredPlans;
  final WorkoutProgramsModel workoutPrograms;

  Map<String, dynamic> toJson() => _$HomeFeedModelToJson(this);

  HomeFeed toEntity() => HomeFeed(
        header: header.toEntity(),
        challenge: todaysChallenge.toEntity(),
        featuredPlans: featuredPlans.map((p) => p.toEntity()).toList(),
        filters: workoutPrograms.filters
            .map((f) => f.toEntity(workoutPrograms.filterIconUrls[f.id] ?? ''))
            .toList(),
        programs: workoutPrograms.items.map((p) => p.toEntity()).toList(),
      );
}

@JsonSerializable(explicitToJson: true)
class HeaderModel {
  const HeaderModel({
    required this.date,
    required this.greeting,
    required this.notification,
  });

  factory HeaderModel.fromJson(Map<String, dynamic> json) =>
      _$HeaderModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String date;
  @JsonKey(defaultValue: '')
  final String greeting;
  final NotificationModel notification;

  Map<String, dynamic> toJson() => _$HeaderModelToJson(this);

  HomeHeader toEntity() => HomeHeader(
        date: date,
        greeting: greeting,
        hasUnreadNotifications: notification.hasUnread,
        notificationIconUrl: notification.iconUrl,
      );
}

@JsonSerializable()
class NotificationModel {
  const NotificationModel({required this.hasUnread, required this.iconUrl});

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  @JsonKey(defaultValue: false)
  final bool hasUnread;
  @JsonKey(defaultValue: '')
  final String iconUrl;

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}

@JsonSerializable()
class ChallengeModel {
  const ChallengeModel({
    required this.title,
    required this.activity,
    required this.completed,
    required this.total,
    required this.progress,
    required this.iconUrl,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) =>
      _$ChallengeModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String title;
  @JsonKey(defaultValue: '')
  final String activity;
  @JsonKey(defaultValue: 0)
  final int completed;
  @JsonKey(defaultValue: 0)
  final int total;
  @JsonKey(defaultValue: 0.0)
  final double progress;
  @JsonKey(defaultValue: '')
  final String iconUrl;

  Map<String, dynamic> toJson() => _$ChallengeModelToJson(this);

  TodaysChallenge toEntity() => TodaysChallenge(
        title: title,
        activity: activity,
        completed: completed,
        total: total,
        iconUrl: iconUrl,
      );
}

@JsonSerializable(explicitToJson: true)
class FeaturedPlanModel {
  const FeaturedPlanModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.frequency,
    required this.actionLabel,
    required this.imageUrl,
    required this.metaIcons,
  });

  factory FeaturedPlanModel.fromJson(Map<String, dynamic> json) =>
      _$FeaturedPlanModelFromJson(json);

  final String id;
  @JsonKey(defaultValue: '')
  final String title;
  @JsonKey(defaultValue: '')
  final String duration;
  @JsonKey(defaultValue: '')
  final String frequency;
  @JsonKey(defaultValue: 'Start Now')
  final String actionLabel;
  @JsonKey(defaultValue: '')
  final String imageUrl;
  final MetaIconsModel metaIcons;

  Map<String, dynamic> toJson() => _$FeaturedPlanModelToJson(this);

  FeaturedPlan toEntity() => FeaturedPlan(
        id: id,
        title: title,
        duration: duration,
        frequency: frequency,
        actionLabel: actionLabel,
        imageUrl: imageUrl,
        durationIconUrl: metaIcons.durationIconUrl,
        frequencyIconUrl: metaIcons.frequencyIconUrl,
      );
}

@JsonSerializable()
class MetaIconsModel {
  const MetaIconsModel({
    required this.durationIconUrl,
    required this.frequencyIconUrl,
  });

  factory MetaIconsModel.fromJson(Map<String, dynamic> json) =>
      _$MetaIconsModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String durationIconUrl;
  @JsonKey(defaultValue: '')
  final String frequencyIconUrl;

  Map<String, dynamic> toJson() => _$MetaIconsModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class WorkoutProgramsModel {
  const WorkoutProgramsModel({
    required this.filters,
    required this.filterIconUrls,
    required this.items,
  });

  factory WorkoutProgramsModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutProgramsModelFromJson(json);

  @JsonKey(defaultValue: <FilterModel>[])
  final List<FilterModel> filters;
  @JsonKey(defaultValue: <String, String>{})
  final Map<String, String> filterIconUrls;
  @JsonKey(defaultValue: <ProgramModel>[])
  final List<ProgramModel> items;

  Map<String, dynamic> toJson() => _$WorkoutProgramsModelToJson(this);
}

@JsonSerializable()
class FilterModel {
  const FilterModel({
    required this.id,
    required this.name,
    required this.selected,
  });

  factory FilterModel.fromJson(Map<String, dynamic> json) =>
      _$FilterModelFromJson(json);

  final String id;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: false)
  final bool selected;

  Map<String, dynamic> toJson() => _$FilterModelToJson(this);

  ProgramFilter toEntity(String iconUrl) => ProgramFilter(
        id: id,
        name: name.isEmpty ? id : name,
        selected: selected,
        iconUrl: iconUrl,
      );
}

@JsonSerializable(explicitToJson: true)
class ProgramModel {
  const ProgramModel({
    required this.id,
    required this.title,
    required this.calories,
    required this.durationMinutes,
    required this.isPro,
    required this.imageUrl,
    required this.icons,
  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) =>
      _$ProgramModelFromJson(json);

  final String id;
  @JsonKey(defaultValue: '')
  final String title;
  @JsonKey(defaultValue: 0)
  final int calories;
  @JsonKey(defaultValue: 0)
  final int durationMinutes;
  @JsonKey(defaultValue: false)
  final bool isPro;
  @JsonKey(defaultValue: '')
  final String imageUrl;
  final ProgramIconsModel icons;

  Map<String, dynamic> toJson() => _$ProgramModelToJson(this);

  WorkoutProgram toEntity() => WorkoutProgram(
        id: id,
        title: title,
        calories: calories,
        durationMinutes: durationMinutes,
        isPro: isPro,
        imageUrl: imageUrl,
        caloriesIconUrl: icons.caloriesIconUrl,
        durationIconUrl: icons.durationIconUrl,
        proIconUrl: icons.proIconUrl,
      );
}

@JsonSerializable()
class ProgramIconsModel {
  const ProgramIconsModel({
    required this.caloriesIconUrl,
    required this.durationIconUrl,
    this.proIconUrl,
  });

  factory ProgramIconsModel.fromJson(Map<String, dynamic> json) =>
      _$ProgramIconsModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String caloriesIconUrl;
  @JsonKey(defaultValue: '')
  final String durationIconUrl;
  final String? proIconUrl;

  Map<String, dynamic> toJson() => _$ProgramIconsModelToJson(this);
}
