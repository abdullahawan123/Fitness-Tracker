import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_tracker/core/theme/app_theme.dart';
import 'package:fitness_tracker/presentation/widgets/custom_widgets.dart';
import 'package:fitness_tracker/presentation/blocs/activity/activity_bloc.dart';
import 'package:fitness_tracker/domain/entities/activity.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ActivityBloc, ActivityState>(
        builder: (context, state) {
          List<Activity> activities = [];
          if (state is ActivitiesLoaded) activities = state.activities;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Analytics',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  _buildChartHeader(context, 'Weekly Progress'),
                  const SizedBox(height: 16),
                  _buildBarChart(context, activities),
                  const SizedBox(height: 32),
                  _buildChartHeader(context, 'Weight Trend'),
                  const SizedBox(height: 16),
                  _buildLineChart(context),
                  const SizedBox(height: 32),
                  _buildStatsSummary(context, activities),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChartHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const Text(
          'Details >',
          style: TextStyle(color: AppColors.primary, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildBarChart(BuildContext context, List<Activity> activities) {
    final dailySteps = List.generate(7, (index) => 0.0);
    final now = DateTime.now();
    for (var a in activities) {
      final diff = now.difference(a.startTime).inDays;
      if (diff < 7 && diff >= 0) {
        dailySteps[6 - diff] += a.steps;
      }
    }

    return SizedBox(
      height: 200,
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: BarChart(
          BarChartData(
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(
              7,
              (i) => _makeGroupData(
                i,
                dailySteps[i] > 0 ? dailySteps[i] : (1000.0 * (i + 1)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.primary,
          width: 12,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 15000,
            color: AppColors.primary.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildLineChart(BuildContext context) {
    return SizedBox(
      height: 200,
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                color: AppColors.accent,
                barWidth: 4,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppColors.accent.withOpacity(0.1),
                ),
                spots: const [
                  FlSpot(0, 75),
                  FlSpot(1, 74.5),
                  FlSpot(2, 74),
                  FlSpot(3, 73.8),
                  FlSpot(4, 74.2),
                  FlSpot(5, 73.5),
                  FlSpot(6, 73),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSummary(BuildContext context, List<Activity> activities) {
    double totalDist = 0;
    double totalCals = 0;
    int totalSteps = 0;
    for (var a in activities) {
      totalDist += a.distance;
      totalCals += a.calories;
      totalSteps += a.steps;
    }

    final avgSteps = activities.isEmpty ? 0 : totalSteps ~/ activities.length;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MiniStatTile(
                label: 'Avg Steps',
                value: avgSteps.toString(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MiniStatTile(
                label: 'Avg Calories',
                value:
                    '${(totalCals / (activities.isEmpty ? 1 : activities.length)).toStringAsFixed(0)} kcal',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: MiniStatTile(
                label: 'Total Distance',
                value: '${totalDist.toStringAsFixed(1)} km',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MiniStatTile(
                label: 'Active Days',
                value: '${activities.length} sessions',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MiniStatTile extends StatelessWidget {
  final String label;
  final String value;
  const MiniStatTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textBody, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
