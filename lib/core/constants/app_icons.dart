/// Iconițele SVG exportate din Figma. Au prioritate față de iconițele din
/// JSON, ca aplicația să arate exact ca designul.
class AppIcons {
  AppIcons._();

  static const String arrowLeft = 'assets/icons/arrow_left.svg';
  static const String barbell = 'assets/icons/barbell.svg';
  static const String bell = 'assets/icons/bell.svg';
  static const String clock = 'assets/icons/clock.svg';
  static const String crown = 'assets/icons/crown.svg';
  static const String dotsVertical = 'assets/icons/dots_vertical.svg';
  static const String flame = 'assets/icons/flame.svg';
  static const String ironingSteam = 'assets/icons/ironing_steam.svg';
  static const String layoutList = 'assets/icons/layout_list.svg';
  static const String star = 'assets/icons/star.svg';
  static const String wifi = 'assets/icons/wifi.svg';

  /// Iconițele facilităților din Figma, după id-ul din JSON.
  static String? amenity(String id) => switch (id) {
        'showers' => ironingSteam,
        'lockers' => layoutList,
        'wifi' => wifi,
        _ => null,
      };
}
