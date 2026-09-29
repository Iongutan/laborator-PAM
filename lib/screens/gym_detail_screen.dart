import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/fitness_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/amenity_tile.dart';
import '../widgets/primary_button.dart';

/// Ecranul „30. Fitness” din Figma — detaliile sălii.
class GymDetailScreen extends StatefulWidget {
  const GymDetailScreen({super.key, required this.gym});

  final Gym gym;

  @override
  State<GymDetailScreen> createState() => _GymDetailScreenState();
}

class _GymDetailScreenState extends State<GymDetailScreen> {
  static const double _gutter = 24;

  bool _expanded = false;
  bool _reserved = false;

  void _reserve() {
    setState(() => _reserved = !_reserved);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(_reserved
              ? 'Reserved ${widget.gym.name}!'
              : 'Reservation cancelled'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.greyscale900,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final Gym gym = widget.gym;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.greyscale0,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHero(gym),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _gutter),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfo(gym),
                    const SizedBox(height: 18),
                    _buildDescription(gym),
                    const SizedBox(height: 16),
                    const Text('Amenities', style: AppTextStyles.largeSemibold),
                    const SizedBox(height: 16),
                    _buildAmenities(gym),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomBar(gym),
      ),
    );
  }

  Widget _buildHero(Gym gym) {
    return SizedBox(
      height: 350,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(gym.image, fit: BoxFit.cover),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(_gutter, 16, _gutter, 0),
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CircleButton(
                        onTap: () => Navigator.of(context).maybePop(),
                        child: SvgPicture.asset(AppIcons.arrowLeft,
                            width: 24, height: 24),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: SvgPicture.asset(AppIcons.dotsVertical,
                            width: 24, height: 24),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(Gym gym) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.greyscale100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(AppIcons.star, width: 16, height: 16),
              const SizedBox(width: 8),
              Text.rich(
                TextSpan(
                  text: '${gym.rating} ',
                  style: AppTextStyles.smallSemibold,
                  children: [
                    TextSpan(
                      text: '(${formatThousands(gym.reviews)} reviews)',
                      style: AppTextStyles.smallRegular
                          .copyWith(color: AppColors.greyscale400),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(gym.name, style: AppTextStyles.h4),
          const SizedBox(height: 8),
          Text(
            gym.location,
            style: AppTextStyles.smallRegular
                .copyWith(color: AppColors.greyscale400),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(Gym gym) {
    final TextStyle body =
        AppTextStyles.smallRegular.copyWith(color: AppColors.greyscale400);
    final TextStyle link =
        AppTextStyles.smallMedium.copyWith(color: AppColors.primary500);

    if (_expanded) {
      return GestureDetector(
        onTap: () => setState(() => _expanded = false),
        child: Text.rich(
          TextSpan(
            text: '${gym.description} ',
            style: body,
            children: [TextSpan(text: 'Show less', style: link)],
          ),
        ),
      );
    }

    // Textul scurt din design (3 rânduri) + „Read more”.
    return GestureDetector(
      onTap: () => setState(() => _expanded = true),
      child: Text.rich(
        TextSpan(
          text: '${shortDescription(gym.description)}... ',
          style: body,
          children: [TextSpan(text: 'Read more', style: link)],
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildAmenities(Gym gym) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: gym.amenities.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 52,
      ),
      itemBuilder: (_, i) => AmenityTile(amenity: gym.amenities[i]),
    );
  }

  Widget _buildBottomBar(Gym gym) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.greyscale0,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, -10),
            blurRadius: 50,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 16, 25, 0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: AppTextStyles.smallMedium
                          .copyWith(color: AppColors.greyscale400),
                    ),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        text: '\$${gym.pricePerWeek.toStringAsFixed(2)} ',
                        style: AppTextStyles.h6,
                        children: [
                          TextSpan(
                            text: '/week',
                            style: AppTextStyles.smallMedium
                                .copyWith(color: AppColors.greyscale400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: PrimaryButton.large(
                  label: _reserved ? 'Reserved' : 'Reserve',
                  onPressed: _reserve,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Back',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}

/// 1232 → „1,232”.
String formatThousands(int value) {
  final String digits = value.toString();
  final StringBuffer out = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) out.write(',');
    out.write(digits[i]);
  }
  return out.toString();
}

/// Primele ~145 de caractere din descriere, tăiate la un cuvânt întreg.
String shortDescription(String text, {int maxLength = 145}) {
  if (text.length <= maxLength) return text;
  final int cut = text.lastIndexOf(' ', maxLength);
  return text.substring(0, cut > 0 ? cut : maxLength).replaceAll(
        RegExp(r'[.,;:]$'),
        '',
      );
}
