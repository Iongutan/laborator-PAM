import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Stilurile de text din Figma. Letter spacing-ul „-2%” din Figma
/// devine -0.02 × mărimea fontului.
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'PlusJakartaSans';

  static TextStyle _body(double size, FontWeight weight) => TextStyle(
        fontFamily: fontFamily,
        fontSize: size,
        fontWeight: weight,
        height: 1.55,
        letterSpacing: -0.02 * size,
        color: AppColors.greyscale900,
      );

  // Heading
  static const TextStyle h4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.5,
    color: AppColors.greyscale900,
  );
  static const TextStyle h6 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: AppColors.greyscale900,
  );

  // Body
  static const TextStyle largeSemibold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.55,
    color: AppColors.greyscale900,
  );
  static final TextStyle mediumSemibold = _body(16, FontWeight.w600);
  static final TextStyle smallRegular = _body(14, FontWeight.w400);
  static final TextStyle smallMedium = _body(14, FontWeight.w500);
  static final TextStyle smallSemibold = _body(14, FontWeight.w600);
  static final TextStyle xSmallRegular = _body(12, FontWeight.w400);
  static final TextStyle xSmallMedium = _body(12, FontWeight.w500);
  static final TextStyle xSmallSemibold = _body(12, FontWeight.w600);
  static final TextStyle xxSmallSemibold = _body(11, FontWeight.w600);
}
