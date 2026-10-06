import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/gym_models.dart';
import '../../logic/gym/gym_details_cubit.dart';
import '../../logic/gym/gym_details_state.dart';
import '../../logic/load_status.dart';
import '../navigation.dart';
import '../widgets/amenity_tile.dart';
import '../widgets/app_network_icon.dart';
import '../widgets/app_network_image.dart';
import '../widgets/primary_button.dart';
import '../widgets/simple_top_bar.dart';
import '../widgets/state_views.dart';

/// Ecranul „30. Fitness” — detaliile sălii, cu datele din lab_v3.json.
class GymDetailsScreen extends StatelessWidget {
  const GymDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GymDetailsCubit, GymDetailsState>(
      listenWhen: (a, b) =>
          a.reserved != b.reserved && b.status == LoadStatus.success,
      listener: (context, state) => showAppMessage(
        context,
        state.reserved
            ? 'Reserved ${state.details!.gym.name}!'
            : 'Reservation cancelled',
      ),
      builder: (context, state) {
        switch (state.status) {
          case LoadStatus.initial:
          case LoadStatus.loading:
            return const Scaffold(
              backgroundColor: AppColors.greyscale0,
              appBar: SimpleTopBar(title: ''),
              body: LoadingView(message: 'Loading gym details...'),
            );
          case LoadStatus.failure:
            return Scaffold(
              backgroundColor: AppColors.greyscale0,
              appBar: const SimpleTopBar(title: ''),
              body: MessageView.error(
                message: state.errorMessage ?? 'Unknown error',
                onRetry: () => context.read<GymDetailsCubit>().load(),
              ),
            );
          case LoadStatus.empty:
            return const Scaffold(
              backgroundColor: AppColors.greyscale0,
              appBar: SimpleTopBar(title: ''),
              body: MessageView.empty(message: 'No details for this gym.'),
            );
          case LoadStatus.success:
            return _GymDetailsContent(state: state);
        }
      },
    );
  }
}

class _GymDetailsContent extends StatelessWidget {
  const _GymDetailsContent({required this.state});

  final GymDetailsState state;

  static const double _gutter = 24;

  @override
  Widget build(BuildContext context) {
    final GymDetails details = state.details!;
    final Gym gym = details.gym;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.greyscale0,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Hero(gym: gym, actions: details.actions),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _gutter),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Info(gym: gym, ratingIconUrl: details.actions.ratingIconUrl),
                    const SizedBox(height: 18),
                    _Description(
                      text: gym.description,
                      expanded: state.descriptionExpanded,
                    ),
                    const SizedBox(height: 16),
                    const Text('Amenities',
                        style: AppTextStyles.largeSemibold),
                    const SizedBox(height: 16),
                    if (gym.amenities.isEmpty)
                      Text(
                        'No amenities listed.',
                        style: AppTextStyles.smallRegular
                            .copyWith(color: AppColors.greyscale400),
                      )
                    else
                      _AmenitiesGrid(amenities: gym.amenities),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _BottomBar(
          pricing: gym.pricing,
          actions: details.actions,
          reserved: state.reserved,
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.gym, required this.actions});

  final Gym gym;
  final GymActions actions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppNetworkImage(id: gym.id, url: gym.heroImageUrl),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              color: Colors.white.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: AppNetworkIcon(
                              url: actions.backIconUrl,
                              asset: AppIcons.arrowLeft,
                              size: 24,
                              color: AppColors.greyscale25,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => showAppMessage(context, 'More options'),
                        child: AppNetworkIcon(
                          url: actions.moreIconUrl,
                          asset: AppIcons.dotsVertical,
                          size: 24,
                          color: AppColors.greyscale0,
                        ),
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
}

class _Info extends StatelessWidget {
  const _Info({required this.gym, required this.ratingIconUrl});

  final Gym gym;
  final String ratingIconUrl;

  @override
  Widget build(BuildContext context) {
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
              AppNetworkIcon(
                url: ratingIconUrl,
                asset: AppIcons.star,
                size: 16,
                color: AppColors.warning100,
              ),
              const SizedBox(width: 8),
              Text.rich(
                TextSpan(
                  text: '${gym.rating} ',
                  style: AppTextStyles.smallSemibold,
                  children: [
                    TextSpan(
                      text: '(${formatThousands(gym.reviewCount)} reviews)',
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
}

class _Description extends StatelessWidget {
  const _Description({required this.text, required this.expanded});

  final String text;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final TextStyle body =
        AppTextStyles.smallRegular.copyWith(color: AppColors.greyscale400);
    final TextStyle link =
        AppTextStyles.smallMedium.copyWith(color: AppColors.primary500);

    return GestureDetector(
      onTap: () => context.read<GymDetailsCubit>().toggleDescription(),
      child: Text.rich(
        TextSpan(
          text: '$text ',
          style: body,
          children: [
            TextSpan(text: expanded ? 'Show less' : 'Read more', style: link),
          ],
        ),
        maxLines: expanded ? null : 3,
        overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
      ),
    );
  }
}

class _AmenitiesGrid extends StatelessWidget {
  const _AmenitiesGrid({required this.amenities});

  final List<Amenity> amenities;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: amenities.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 52,
      ),
      itemBuilder: (_, i) => AmenityTile(amenity: amenities[i]),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.pricing,
    required this.actions,
    required this.reserved,
  });

  final Pricing pricing;
  final GymActions actions;
  final bool reserved;

  @override
  Widget build(BuildContext context) {
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
                        text: '${pricing.amountLabel} ',
                        style: AppTextStyles.h6,
                        children: [
                          TextSpan(
                            text: '/${pricing.period}',
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
                  label: reserved ? 'Reserved' : actions.reserveLabel,
                  onPressed: actions.reserveEnabled
                      ? () =>
                          context.read<GymDetailsCubit>().toggleReservation()
                      : null,
                ),
              ),
            ],
          ),
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
