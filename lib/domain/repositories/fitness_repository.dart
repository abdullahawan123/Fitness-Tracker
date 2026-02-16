import 'package:fitness_tracker/domain/entities/activity.dart';
import 'package:fitness_tracker/domain/entities/user.dart';

abstract class FitnessRepository {
  // Activity
  Future<List<Activity>> getActivities();
  Future<void> saveActivity(Activity activity);

  // Real-time
  Stream<int> getStepCount();
  Stream<double> getLiveDistance();

  // User
  Future<User> getUser();
  Future<void> saveUser(User user);

  // Health API
  Future<bool> requestHealthPermissions();
  Future<int> getRecentHealthSteps();
}
