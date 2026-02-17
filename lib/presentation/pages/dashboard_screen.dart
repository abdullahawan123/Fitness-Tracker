import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_tracker/core/theme/app_theme.dart';
import 'package:fitness_tracker/presentation/blocs/activity/activity_bloc.dart';
import 'package:fitness_tracker/presentation/blocs/user/user_bloc.dart';
import 'package:fitness_tracker/presentation/widgets/custom_widgets.dart';
import 'package:fitness_tracker/domain/entities/activity.dart';
import 'package:fitness_tracker/domain/usecases/ai_insight_service.dart';

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
    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        double calories = 0;
        double distance = 0;
        if (state is ActivitiesLoaded) {
          calories = state.todayCalories;
          distance = state.todayDistance;
        }

        return Row(
          children: [
            Expanded(
              child: StatCard(
                label: 'Calories',
                value: calories.toStringAsFixed(0),
                unit: 'kcal',
                icon: Icons.local_fire_department_rounded,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatCard(
                label: 'Distance',
                value: distance.toStringAsFixed(1),
                unit: 'km',
                icon: Icons.location_on_rounded,
                color: Colors.blue,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAIInsight(BuildContext context) {
    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        String insight = "Analyzing your activity...";
        if (state is ActivitiesLoaded) {
          insight = AIInsightService.getInsight(
            state.activities,
            state.todaySteps,
          );
        }

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
                child: const Icon(
                  Icons.psychology_rounded,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AI Insight',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      insight,
                      style: const TextStyle(
                        color: AppColors.textBody,
                        fontSize: 12,
                      ),
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

  Widget _buildRecentActivity(BuildContext context) {
    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        List<Activity> activities = [];
        if (state is ActivitiesLoaded) activities = state.activities;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            if (activities.isEmpty)
              const Center(
                child: Text(
                  'No recent activities',
                  style: TextStyle(color: AppColors.textBody),
                ),
              )
            else
              ...activities.take(3).map((a) => ActivityListItem(activity: a)),
          ],
        );
      },
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
  final Activity activity;
  const ActivityListItem({super.key, required this.activity});

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
              child: Icon(
                activity.type == ActivityType.running
                    ? Icons.directions_run
                    : activity.type == ActivityType.walking
                    ? Icons.directions_walk
                    : Icons.directions_bike,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.type.name.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${(activity.duration / 60).toStringAsFixed(0)} mins • ${activity.distance.toStringAsFixed(1)} km',
                    style: const TextStyle(
                      color: AppColors.textBody,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '+${activity.calories.toStringAsFixed(0)} kcal',
              style: const TextStyle(
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
