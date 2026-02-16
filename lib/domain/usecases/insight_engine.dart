import 'package:fitness_tracker/domain/entities/activity.dart';

class InsightEngine {
  static String? detectFatigue(List<Activity> activities) {
    if (activities.length < 5) return null;

    // Compare last 2 days with 3 days before that
    final stepsByDay = _getDailySteps(activities);
    if (stepsByDay.length < 5) return null;

    final lastTwoAvg = (stepsByDay[0] + stepsByDay[1]) / 2;
    final previousThreeAvg =
        (stepsByDay[2] + stepsByDay[3] + stepsByDay[4]) / 3;

    // If activity dropped by more than 40%, flag fatigue
    if (lastTwoAvg < previousThreeAvg * 0.6) {
      return "We've noticed a significant drop in your activity. You might be fatigued. Consider a recovery day!";
    }

    return null;
  }

  static List<int> _getDailySteps(List<Activity> activities) {
    // Simplified: assuming activities are sorted by date
    final Map<String, int> daily = {};
    for (var a in activities) {
      final date = a.startTime.toIso8601String().split('T')[0];
      daily[date] = (daily[date] ?? 0) + a.steps;
    }
    return daily.values.toList().reversed.toList();
  }
}
