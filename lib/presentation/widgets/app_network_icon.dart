import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/repositories/svg_icon_cache.dart';

/// Iconiță SVG: cea din Figma ([asset]) dacă există, altfel cea din
/// URL-ul din JSON, încărcată asincron.
class AppNetworkIcon extends StatelessWidget {
  const AppNetworkIcon({
    super.key,
    this.asset,
    this.url = '',
    this.size = 20,
    this.color,
  });

  final String? asset;
  final String url;
  final double size;

  /// Culoare opțională (suprascrie culoarea din SVG).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ColorFilter? filter =
        color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn);
    final Widget empty = SizedBox.square(dimension: size);

    if (asset != null) {
      return SvgPicture.asset(asset!,
          width: size, height: size, colorFilter: filter);
    }
    if (url.isEmpty) return empty;

    return FutureBuilder<String?>(
      future: SvgIconCache.load(url),
      builder: (context, snapshot) {
        final String? svg = snapshot.data;
        if (svg == null) return empty;
        return SvgPicture.string(svg,
            width: size, height: size, colorFilter: filter);
      },
    );
  }
}
