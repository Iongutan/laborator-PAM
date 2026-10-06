import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Bara de sus pentru ecranele secundare (buton înapoi + titlu).
class SimpleTopBar extends StatelessWidget implements PreferredSizeWidget {
  const SimpleTopBar({super.key, required this.title});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Row(
          children: [
            Semantics(
              button: true,
              label: 'Back',
              child: GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.greyscale100),
                  ),
                  child: const Icon(Icons.arrow_back,
                      color: AppColors.greyscale900),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: AppTextStyles.h6)),
          ],
        ),
      ),
    );
  }
}
