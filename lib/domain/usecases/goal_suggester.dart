import 'package:fitness_tracker/domain/entities/activity.dart';

class GoalSuggester {
  static int suggestSteps(List<Activity> recentActivities) {
    if (recentActivities.isEmpty) return 10000;

    // Take activities from last 7 days
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    final weeklyActivities = recentActivities
        .where((a) => a.startTime.isAfter(sevenDaysAgo))
        .toList();

    if (weeklyActivities.isEmpty) return 10000;

    // Calculate average steps per day (roughly)
    int totalSteps = weeklyActivities.fold(0, (sum, a) => sum + a.steps);
    int avgSteps = totalSteps ~/ 7;

    // Suggest 10% more than average to encourage growth
    int suggestion = (avgSteps * 1.1).toInt();

    // Round to nearest 500
    suggestion = (suggestion ~/ 500) * 500;

    // Minimum 5000, Maximum 25000
    if (suggestion < 5000) return 5000;
    if (suggestion > 25000) return 25000;

    return suggestion;
  }
}
