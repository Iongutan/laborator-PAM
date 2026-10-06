import 'package:flutter/painting.dart';

/// Fotografiile originale din Figma, asociate după id-ul din JSON.
/// Elementele care nu există în Figma folosesc imaginea din URL-ul din JSON.
class FigmaImage {
  const FigmaImage(this.asset, {this.alignment = Alignment.center});

  final String asset;
  final Alignment alignment;
}

class AppImages {
  AppImages._();

  static const Map<String, FigmaImage> byId = {
    'fp001': FigmaImage('assets/images/featured.jpg'),
    'wp001': FigmaImage('assets/images/yoga.jpg'),
    // În Figma poza e deplasată cu -19.87% spre stânga.
    'wp002': FigmaImage('assets/images/arm.jpg', alignment: Alignment(-0.49, 0)),
    'gym001': FigmaImage('assets/images/gym.jpg'),
  };

  static FigmaImage? forId(String id) => byId[id];
}
