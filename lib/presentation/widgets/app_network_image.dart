import 'package:flutter/material.dart';

import '../../core/constants/app_images.dart';
import '../../core/theme/app_colors.dart';

/// Imagine pentru un element din JSON: fotografia din Figma dacă există
/// pentru [id], altfel imaginea din [url], cu stări de încărcare și eroare.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.id,
    required this.url,
    this.fit = BoxFit.cover,
  });

  final String id;
  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final FigmaImage? figma = AppImages.forId(id);
    if (figma != null) {
      return Image.asset(figma.asset, fit: fit, alignment: figma.alignment);
    }
    if (url.isEmpty) return const _ImagePlaceholder(error: true);
    return Image.network(
      url,
      fit: fit,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : const _ImagePlaceholder(),
      errorBuilder: (context, error, stack) =>
          const _ImagePlaceholder(error: true),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({this.error = false});

  final bool error;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.greyscale700,
      alignment: Alignment.center,
      child: error
          ? const Icon(Icons.image_not_supported_outlined,
              color: AppColors.greyscale400)
          : const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary500,
              ),
            ),
    );
  }
}
