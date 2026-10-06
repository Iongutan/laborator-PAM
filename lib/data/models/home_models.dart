import 'package:equatable/equatable.dart';

// Modelele pentru prima pagină (fitnessHomePage din lab_v3.json).

class HomeHeader extends Equatable {
  const HomeHeader({
    required this.date,
    required this.greeting,
    required this.hasUnreadNotifications,
    required this.notificationIconUrl,
  });

  factory HomeHeader.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> notification =
        json['notification'] as Map<String, dynamic>? ?? const {};
    return HomeHeader(
      date: json['date'] as String? ?? '',
      greeting: json['greeting'] as String? ?? '',
      hasUnreadNotifications: notification['hasUnread'] as bool? ?? false,
      notificationIconUrl: notification['iconUrl'] as String? ?? '',
    );
  }

  final String date;
  final String greeting;
  final bool hasUnreadNotifications;
  final String notificationIconUrl;

  @override
  List<Object?> get props =>
      [date, greeting, hasUnreadNotifications, notificationIconUrl];
}

class TodaysChallenge extends Equatable {
  const TodaysChallenge({
    required this.title,
    required this.activity,
    required this.completed,
    required this.total,
    required this.iconUrl,
  });

  factory TodaysChallenge.fromJson(Map<String, dynamic> json) =>
      TodaysChallenge(
        title: json['title'] as String? ?? '',
        activity: json['activity'] as String? ?? '',
        completed: (json['completed'] as num?)?.toInt() ?? 0,
        total: (json['total'] as num?)?.toInt() ?? 0,
        iconUrl: json['iconUrl'] as String? ?? '',
      );

  final String title;
  final String activity;
  final int completed;
  final int total;
  final String iconUrl;

  double get progress => total == 0 ? 0 : (completed / total).clamp(0.0, 1.0);

  TodaysChallenge copyWith({int? completed}) => TodaysChallenge(
        title: title,
        activity: activity,
        completed: completed ?? this.completed,
        total: total,
        iconUrl: iconUrl,
      );

  @override
  List<Object?> get props => [title, activity, completed, total, iconUrl];
}

class FeaturedPlan extends Equatable {
  const FeaturedPlan({
    required this.id,
    required this.title,
    required this.duration,
    required this.frequency,
    required this.actionLabel,
    required this.imageUrl,
    required this.durationIconUrl,
    required this.frequencyIconUrl,
  });

  factory FeaturedPlan.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> icons =
        json['metaIcons'] as Map<String, dynamic>? ?? const {};
    return FeaturedPlan(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      frequency: json['frequency'] as String? ?? '',
      actionLabel: json['actionLabel'] as String? ?? 'Start Now',
      imageUrl: json['imageUrl'] as String? ?? '',
      durationIconUrl: icons['durationIconUrl'] as String? ?? '',
      frequencyIconUrl: icons['frequencyIconUrl'] as String? ?? '',
    );
  }

  final String id;
  final String title;
  final String duration;
  final String frequency;
  final String actionLabel;
  final String imageUrl;
  final String durationIconUrl;
  final String frequencyIconUrl;

  @override
  List<Object?> get props => [
        id,
        title,
        duration,
        frequency,
        actionLabel,
        imageUrl,
        durationIconUrl,
        frequencyIconUrl,
      ];
}

class ProgramFilter extends Equatable {
  const ProgramFilter({
    required this.id,
    required this.name,
    required this.selected,
    required this.iconUrl,
  });

  factory ProgramFilter.fromJson(
    Map<String, dynamic> json,
    Map<String, dynamic> iconUrls,
  ) {
    final String id = json['id'] as String;
    return ProgramFilter(
      id: id,
      name: json['name'] as String? ?? id,
      selected: json['selected'] as bool? ?? false,
      iconUrl: iconUrls[id] as String? ?? '',
    );
  }

  /// Id-ul filtrului care afișează toate programele.
  static const String allId = 'all';

  final String id;
  final String name;
  final bool selected;
  final String iconUrl;

  bool get isAll => id == allId;

  @override
  List<Object?> get props => [id, name, selected, iconUrl];
}

class WorkoutProgram extends Equatable {
  const WorkoutProgram({
    required this.id,
    required this.title,
    required this.calories,
    required this.durationMinutes,
    required this.isPro,
    required this.imageUrl,
    required this.caloriesIconUrl,
    required this.durationIconUrl,
    this.proIconUrl,
  });

  factory WorkoutProgram.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> icons =
        json['icons'] as Map<String, dynamic>? ?? const {};
    return WorkoutProgram(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      isPro: json['isPro'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String? ?? '',
      caloriesIconUrl: icons['caloriesIconUrl'] as String? ?? '',
      durationIconUrl: icons['durationIconUrl'] as String? ?? '',
      proIconUrl: icons['proIconUrl'] as String?,
    );
  }

  final String id;
  final String title;
  final int calories;
  final int durationMinutes;
  final bool isPro;
  final String imageUrl;
  final String caloriesIconUrl;
  final String durationIconUrl;
  final String? proIconUrl;

  /// JSON-ul nu are o categorie explicită, așa că un program aparține unui
  /// filtru dacă titlul conține numele filtrului (ex: „Cardio Training” → Cardio).
  bool matchesFilter(ProgramFilter filter) =>
      filter.isAll || title.toLowerCase().contains(filter.name.toLowerCase());

  @override
  List<Object?> get props => [
        id,
        title,
        calories,
        durationMinutes,
        isPro,
        imageUrl,
        caloriesIconUrl,
        durationIconUrl,
        proIconUrl,
      ];
}

class FitnessHome extends Equatable {
  const FitnessHome({
    required this.header,
    required this.challenge,
    required this.featuredPlans,
    required this.filters,
    required this.programs,
  });

  factory FitnessHome.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> workout =
        json['workoutPrograms'] as Map<String, dynamic>? ?? const {};
    final Map<String, dynamic> filterIcons =
        workout['filterIconUrls'] as Map<String, dynamic>? ?? const {};
    return FitnessHome(
      header: HomeHeader.fromJson(json['header'] as Map<String, dynamic>),
      challenge: TodaysChallenge.fromJson(
          json['todaysChallenge'] as Map<String, dynamic>),
      featuredPlans: (json['featuredPlans'] as List<dynamic>? ?? const [])
          .map((e) => FeaturedPlan.fromJson(e as Map<String, dynamic>))
          .toList(),
      filters: (workout['filters'] as List<dynamic>? ?? const [])
          .map((e) =>
              ProgramFilter.fromJson(e as Map<String, dynamic>, filterIcons))
          .toList(),
      programs: (workout['items'] as List<dynamic>? ?? const [])
          .map((e) => WorkoutProgram.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final HomeHeader header;
  final TodaysChallenge challenge;
  final List<FeaturedPlan> featuredPlans;
  final List<ProgramFilter> filters;
  final List<WorkoutProgram> programs;

  /// Filtrul marcat „selected” în JSON (sau primul).
  String get initialFilterId => filters
      .firstWhere((f) => f.selected,
          orElse: () => filters.isNotEmpty
              ? filters.first
              : const ProgramFilter(
                  id: ProgramFilter.allId,
                  name: 'All Type',
                  selected: true,
                  iconUrl: '',
                ))
      .id;

  bool get isEmpty => featuredPlans.isEmpty && programs.isEmpty;

  @override
  List<Object?> get props =>
      [header, challenge, featuredPlans, filters, programs];
}
