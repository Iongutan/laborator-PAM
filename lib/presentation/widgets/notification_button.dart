import 'package:flutter/material.dart';

import '../../core/constants/app_icons.dart';
import '../../core/theme/app_colors.dart';
import 'app_network_icon.dart';

/// Butonul rotund cu clopoțel și punct roșu pentru notificări necitite.
class NotificationButton extends StatelessWidget {
  const NotificationButton({
    super.key,
    required this.iconUrl,
    required this.hasUnread,
    required this.onTap,
  });

  final String iconUrl;
  final bool hasUnread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Notifications',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.greyscale100),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AppNetworkIcon(
                url: iconUrl,
                fallbackAsset: AppIcons.bell,
                size: 24,
                color: AppColors.greyscale900,
              ),
              if (hasUnread)
                Positioned(
                  left: 26,
                  top: 17,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.error100,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
