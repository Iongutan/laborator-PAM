import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/home_models.dart';
import '../navigation.dart';
import '../widgets/featured_card.dart';
import '../widgets/simple_top_bar.dart';
import '../widgets/state_views.dart';

/// „See All” pentru Featured Plan: toate planurile, unul sub altul.
class PlansScreen extends StatelessWidget {
  const PlansScreen({super.key, required this.plans});

  final List<FeaturedPlan> plans;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyscale0,
      appBar: const SimpleTopBar(title: 'Featured Plans'),
      body: plans.isEmpty
          ? const MessageView.empty(message: 'No featured plans yet.')
          : LayoutBuilder(
              builder: (context, constraints) => ListView.separated(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                itemCount: plans.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (_, i) => FeaturedCard(
                  plan: plans[i],
                  width: constraints.maxWidth - 48,
                  onStart: () => openGymDetails(context),
                ),
              ),
            ),
    );
  }
}
