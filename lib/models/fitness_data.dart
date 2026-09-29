import 'package:flutter/painting.dart';

// Datele afișate în aplicație (conținutul din designul Figma).

class FeaturedPlan {
  const FeaturedPlan({
    required this.title,
    required this.weeks,
    required this.timesPerWeek,
    required this.image,
  });

  final String title;
  final int weeks;
  final int timesPerWeek;
  final String image;
}

class WorkoutProgram {
  const WorkoutProgram({
    required this.title,
    required this.categories,
    required this.kcal,
    required this.minutes,
    required this.image,
    this.isPro = false,
    this.imageAlignment = Alignment.center,
  });

  final String title;
  final List<String> categories;
  final int kcal;
  final int minutes;
  final String image;
  final bool isPro;

  /// Încadrarea pozei în card (ca în Figma).
  final Alignment imageAlignment;
}

class Amenity {
  const Amenity({required this.label, required this.icon});

  final String label;
  final String icon;
}

class Gym {
  const Gym({
    required this.name,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.description,
    required this.pricePerWeek,
    required this.image,
    required this.amenities,
  });

  final String name;
  final String location;
  final double rating;
  final int reviews;
  final String description;
  final double pricePerWeek;
  final String image;
  final List<Amenity> amenities;
}

class AppImages {
  AppImages._();

  static const String gym = 'assets/images/gym.jpg';
  static const String featured = 'assets/images/featured.jpg';
  static const String yoga = 'assets/images/yoga.jpg';
  static const String arm = 'assets/images/arm.jpg';
}

class AppIcons {
  AppIcons._();

  static const String arrowLeft = 'assets/icons/arrow_left.svg';
  static const String barbell = 'assets/icons/barbell.svg';
  static const String bellButton = 'assets/icons/bell_button.svg';
  static const String clock = 'assets/icons/clock.svg';
  static const String crown = 'assets/icons/crown.svg';
  static const String dotsVertical = 'assets/icons/dots_vertical.svg';
  static const String flame = 'assets/icons/flame.svg';
  static const String ironingSteam = 'assets/icons/ironing_steam.svg';
  static const String layoutList = 'assets/icons/layout_list.svg';
  static const String star = 'assets/icons/star.svg';
  static const String wifi = 'assets/icons/wifi.svg';
}

const List<String> workoutCategories = [
  'All Type',
  'Pilates',
  'Cardio',
  'Boxing',
  'Yoga',
];

const List<FeaturedPlan> featuredPlans = [
  FeaturedPlan(
    title: 'Massive Upper Body',
    weeks: 5,
    timesPerWeek: 4,
    image: AppImages.featured,
  ),
  FeaturedPlan(
    title: 'Massive Upper Body',
    weeks: 5,
    timesPerWeek: 4,
    image: AppImages.featured,
  ),
];

const List<WorkoutProgram> workoutPrograms = [
  WorkoutProgram(
    title: 'Yoga',
    categories: ['Yoga', 'Pilates'],
    kcal: 210,
    minutes: 120,
    image: AppImages.yoga,
  ),
  WorkoutProgram(
    title: 'Arm\nStrengthening',
    categories: ['Cardio', 'Boxing'],
    kcal: 210,
    minutes: 120,
    image: AppImages.arm,
    isPro: true,
    // În Figma poza e deplasată cu -19.87% spre stânga.
    imageAlignment: Alignment(-0.49, 0),
  ),
];

const Gym midCityGym = Gym(
  name: 'Mid City Gym Training',
  location: 'California, New York',
  rating: 4.5,
  reviews: 1232,
  description:
      'Lorem ipsum dolor sit amet consectetur. Blandit vitae aliquet eros '
      'laoreet quam sollicitudin. Duis non eu habitant id vel nisi eget amet '
      'tellus. Pellentesque habitant morbi tristique senectus et netus et '
      'malesuada fames ac turpis egestas. Sed euismod, urna eu tincidunt '
      'consectetur, nisi nisl aliquam nunc, eget aliquam massa nisl quis neque.',
  pricePerWeek: 69,
  image: AppImages.gym,
  amenities: [
    Amenity(label: 'Showers', icon: AppIcons.ironingSteam),
    Amenity(label: 'Lockers', icon: AppIcons.layoutList),
    Amenity(label: 'Free Wi-fi', icon: AppIcons.wifi),
    Amenity(label: 'Free Wi-fi', icon: AppIcons.wifi),
  ],
);
