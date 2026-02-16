import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_tracker/core/theme/app_theme.dart';
import 'package:fitness_tracker/presentation/blocs/activity/activity_bloc.dart';
import 'package:fitness_tracker/presentation/blocs/user/user_bloc.dart';
import 'package:fitness_tracker/presentation/widgets/custom_widgets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildAIInsight(context),
              const SizedBox(height: 24),
              _buildStepProgress(context),
              const SizedBox(height: 32),
              _buildStatGrid(context),
              const SizedBox(height: 32),
              _buildRecentActivity(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        String name = 'Fitness Pro';
        if (state is UserLoaded) name = state.user.name;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $name!',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Stay Active',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            const CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(
                'https://api.dicebear.com/7.x/avataaars/svg?seed=Felix',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStepProgress(BuildContext context) {
    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        int steps = 0;
        if (state is ActivitiesLoaded) steps = state.todaySteps;

        double progress = steps / 10000;
        if (progress > 1.0) progress = 1.0;

        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 220,
                width: 220,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 20,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  color: AppColors.primary,
                  strokeCap: StrokeCap.round,
                ),
              ),
              GlassCard(
                borderRadius: 100,
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    const Icon(
                      Icons.bolt,
                      color: AppColors.neonGreen,
                      size: 32,
                    ),
                    Text(
                      steps.toString(),
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Text(
                      'Steps Today',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatGrid(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: StatCard(
            label: 'Calories',
            value: '420',
            unit: 'kcal',
            icon: Icons.local_fire_department_rounded,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: StatCard(
            label: 'Distance',
            value: '3.4',
            unit: 'km',
            icon: Icons.location_on_rounded,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildAIInsight(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.psychology_rounded, color: Colors.amber),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Insight',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  'Your activity is 20% higher than last week. Keep it up!',
                  style: TextStyle(color: AppColors.textBody, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        const ActivityListItem(),
        const ActivityListItem(),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  unit,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class ActivityListItem extends StatelessWidget {
  const ActivityListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.directions_run, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Morning Run',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '45 mins • 5.2 km',
                    style: TextStyle(color: AppColors.textBody, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Text(
              '+320 kcal',
              style: TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
