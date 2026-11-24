import 'package:equatable/equatable.dart';

// Entitățile paginii Home (domain). Nu știu nimic de JSON sau HTTP.

class HomeHeader extends Equatable {
  const HomeHeader({
    required this.date,
    required this.greeting,
    required this.hasUnreadNotifications,
    required this.notificationIconUrl,
  });

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

  final String id;
  final String title;
  final int calories;
  final int durationMinutes;
  final bool isPro;
  final String imageUrl;
  final String caloriesIconUrl;
  final String durationIconUrl;
  final String? proIconUrl;

  /// API-ul nu trimite o categorie, așa că un program aparține unui filtru
  /// dacă titlul conține numele filtrului (ex: „Cardio Training” → Cardio).
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

class HomeFeed extends Equatable {
  const HomeFeed({
    required this.header,
    required this.challenge,
    required this.featuredPlans,
    required this.filters,
    required this.programs,
  });

  final HomeHeader header;
  final TodaysChallenge challenge;
  final List<FeaturedPlan> featuredPlans;
  final List<ProgramFilter> filters;
  final List<WorkoutProgram> programs;

  /// Filtrul marcat „selected” de server (sau „all”).
  String get initialFilterId {
    for (final ProgramFilter f in filters) {
      if (f.selected) return f.id;
    }
    return filters.isNotEmpty ? filters.first.id : ProgramFilter.allId;
  }

  bool get isEmpty => featuredPlans.isEmpty && programs.isEmpty;

  HomeFeed copyWith({TodaysChallenge? challenge}) => HomeFeed(
        header: header,
        challenge: challenge ?? this.challenge,
        featuredPlans: featuredPlans,
        filters: filters,
        programs: programs,
      );

  @override
  List<Object?> get props =>
      [header, challenge, featuredPlans, filters, programs];
}
