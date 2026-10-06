import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Imagine din rețea (URL din JSON) cu stare de încărcare și de eroare.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
  });

  final String url;
  final BoxFit fit;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return const _ImagePlaceholder(error: true);
    return Image.network(
      url,
      fit: fit,
      alignment: alignment,
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
