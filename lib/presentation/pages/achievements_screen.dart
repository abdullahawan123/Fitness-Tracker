import 'package:flutter/material.dart';
import 'package:fitness_tracker/core/theme/app_theme.dart';
import 'package:fitness_tracker/presentation/widgets/custom_widgets.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Achievements',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Unlock badges by staying active',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              _buildBadgesGrid(context),
              const SizedBox(height: 40),
              _buildMilestones(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadgesGrid(BuildContext context) {
    final badges = [
      BadgeData(name: 'Early Bird', icon: Icons.wb_sunny, unlocked: true),
      BadgeData(name: '10k Hero', icon: Icons.directions_run, unlocked: true),
      BadgeData(
        name: 'Streak King',
        icon: Icons.local_fire_department,
        unlocked: true,
      ),
      BadgeData(name: 'Mountain Mover', icon: Icons.terrain, unlocked: false),
      BadgeData(
        name: 'Night Owl',
        icon: Icons.nightlight_round,
        unlocked: false,
      ),
      BadgeData(name: 'Marathoner', icon: Icons.timer, unlocked: false),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: badges.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final badge = badges[index];
        return Column(
          children: [
            Expanded(
              child: GlassCard(
                borderRadius: 16,
                padding: const EdgeInsets.all(12),
                child: Center(
                  child: Icon(
                    badge.icon,
                    size: 32,
                    color: badge.unlocked
                        ? AppColors.neonGreen
                        : Colors.grey.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              badge.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: badge.unlocked ? Colors.white : AppColors.textBody,
                fontWeight: badge.unlocked
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMilestones(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('In Progress', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        const MilestoneCard(
          title: 'Walk 100km total',
          current: 64,
          total: 100,
          unit: 'km',
        ),
        const MilestoneCard(
          title: 'Burn 5000 kcal',
          current: 3200,
          total: 5000,
          unit: 'kcal',
        ),
      ],
    );
  }
}

class BadgeData {
  final String name;
  final IconData icon;
  final bool unlocked;
  BadgeData({required this.name, required this.icon, required this.unlocked});
}

class MilestoneCard extends StatelessWidget {
  final String title;
  final double current;
  final double total;
  final String unit;

  const MilestoneCard({
    super.key,
    required this.title,
    required this.current,
    required this.total,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    double progress = current / total;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${current.toInt()}/${total.toInt()} $unit',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
