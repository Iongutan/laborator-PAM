import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'primary_button.dart';

/// Starea „Loading”.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message = 'Loading...'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.primary500),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTextStyles.smallMedium
                .copyWith(color: AppColors.greyscale400),
          ),
        ],
      ),
    );
  }
}

/// Mesaj centrat cu iconiță, titlu, text și buton opțional.
/// Folosit pentru stările „Empty” și „Error”.
class MessageView extends StatelessWidget {
  const MessageView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor = AppColors.greyscale400,
  });

  /// Starea „Error”, cu buton „Try again”.
  const MessageView.error({
    super.key,
    required this.message,
    required VoidCallback onRetry,
  })  : icon = Icons.error_outline,
        title = 'Something went wrong',
        actionLabel = 'Try again',
        onAction = onRetry,
        iconColor = AppColors.error100;

  /// Starea „Empty”.
  const MessageView.empty({
    super.key,
    this.title = 'Nothing here yet',
    required this.message,
    this.actionLabel,
    this.onAction,
  })  : icon = Icons.inbox_outlined,
        iconColor = AppColors.greyscale400;

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: iconColor),
            const SizedBox(height: 12),
            Text(title,
                style: AppTextStyles.h6, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.smallRegular
                  .copyWith(color: AppColors.greyscale400),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              PrimaryButton.small(label: actionLabel!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}
