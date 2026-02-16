import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fitness_tracker/core/theme/app_theme.dart';
import 'package:fitness_tracker/presentation/widgets/custom_widgets.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

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
                'Analytics',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              _buildChartHeader(context, 'Weekly Progress'),
              const SizedBox(height: 16),
              _buildBarChart(context),
              const SizedBox(height: 32),
              _buildChartHeader(context, 'Weight Trend'),
              const SizedBox(height: 16),
              _buildLineChart(context),
              const SizedBox(height: 32),
              _buildStatsSummary(context),
            ],
          ),
        ),
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
        Text(
          'Details >',
          style: TextStyle(color: AppColors.primary, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildBarChart(BuildContext context) {
    return SizedBox(
      height: 200,
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: BarChart(
          BarChartData(
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            barGroups: [
              _makeGroupData(0, 5000),
              _makeGroupData(1, 7500),
              _makeGroupData(2, 9000),
              _makeGroupData(3, 11000),
              _makeGroupData(4, 8000),
              _makeGroupData(5, 12000),
              _makeGroupData(6, 6000),
            ],
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

  Widget _buildStatsSummary(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MiniStatTile(label: 'Avg Steps', value: '8,432'),
            ),
            SizedBox(width: 16),
            Expanded(
              child: MiniStatTile(label: 'Avg Calories', value: '540 kcal'),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: MiniStatTile(label: 'Total Distance', value: '124 km'),
            ),
            SizedBox(width: 16),
            Expanded(
              child: MiniStatTile(label: 'Active Days', value: '24 days'),
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
