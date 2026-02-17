import 'package:fitness_tracker/domain/entities/activity.dart';

class AIInsightService {
  static String getInsight(List<Activity> activities, int todaySteps) {
    if (activities.isEmpty) {
      return "Start your first activity to get personalized AI insights!";
    }

    final now = DateTime.now();
    final thisWeekActivities = activities
        .where(
          (a) => a.startTime.isAfter(now.subtract(const Duration(days: 7))),
        )
        .toList();

    if (thisWeekActivities.length > 5) {
      return "You're on fire! 5+ activities this week. Consider a recovery day tomorrow.";
    }

    if (todaySteps > 8000) {
      return "Great job! You've almost hit the 10k mark. a 15-min walk will get you there.";
    }

    // Fatigue detection
    final last3DaysSteps = activities
        .where(
          (a) => a.startTime.isAfter(now.subtract(const Duration(days: 3))),
        )
        .fold(0, (sum, a) => sum + a.steps);

    if (last3DaysSteps < 5000 && activities.length > 3) {
      return "Fatigue Detection: Your activity level has dropped. Remember to stay hydrated and rest!";
    }

    return "AI Goal: Try to hit 5,000 steps before 6 PM to stay on track for your daily goal.";
  }
}
