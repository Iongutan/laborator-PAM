import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/repositories/svg_icon_cache.dart';

/// Iconiță SVG din rețea (URL din JSON), încărcată asincron.
/// Dacă nu se poate încărca (fără internet), se afișează iconița locală din Figma.
class AppNetworkIcon extends StatelessWidget {
  const AppNetworkIcon({
    super.key,
    required this.url,
    required this.fallbackAsset,
    this.size = 20,
    this.color,
  });

  final String url;
  final String fallbackAsset;
  final double size;

  /// Culoare opțională (suprascrie culoarea din SVG).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ColorFilter? filter =
        color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn);
    final Widget fallback = SvgPicture.asset(
      fallbackAsset,
      width: size,
      height: size,
      colorFilter: filter,
    );
    if (url.isEmpty) return fallback;

    return FutureBuilder<String?>(
      future: SvgIconCache.load(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SizedBox.square(dimension: size);
        }
        final String? svg = snapshot.data;
        if (svg == null) return fallback;
        return SvgPicture.string(
          svg,
          width: size,
          height: size,
          colorFilter: filter,
        );
      },
    );
  }
}
