import 'package:flutter/material.dart';
import 'package:fitness_tracker/core/theme/app_theme.dart';
import 'package:fitness_tracker/presentation/pages/home_page.dart';
import 'package:fitness_tracker/presentation/widgets/custom_widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get_it/get_it.dart';
import 'package:fitness_tracker/domain/repositories/fitness_repository.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  Future<void> _requestPermissions(BuildContext context) async {
    // Request basic permissions first
    await [
      Permission.activityRecognition,
      Permission.location,
      Permission.sensors,
      Permission.notification,
    ].request();

    // Then request background location (separate dialog on Android 11+)
    await Permission.locationAlways.request();

    // Request Health Permissions
    try {
      final repository = GetIt.I<FitnessRepository>();
      await repository.requestHealthPermissions();
    } catch (e) {
      debugPrint('Health permissions error: $e');
    }

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.security, size: 100, color: AppColors.primary),
            const SizedBox(height: 40),
            Text(
              'Permissions Required',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const Text(
              'To track your activity, distance, and health stats, we need access to your sensors and location.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textBody),
            ),
            const SizedBox(height: 60),
            _PermissionTile(
              icon: Icons.directions_run,
              title: 'Activity Recognition',
              subtitle: 'Used to count your daily steps.',
            ),
            _PermissionTile(
              icon: Icons.location_on,
              title: 'Location Services',
              subtitle: 'Required for real-time jogging maps.',
            ),
            const Spacer(),
            AnimatedGradientButton(
              text: 'Grant Access',
              onPressed: () => _requestPermissions(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
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
  }
}
