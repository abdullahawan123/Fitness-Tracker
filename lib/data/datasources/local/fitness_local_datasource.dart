import 'package:fitness_tracker/data/models/activity_model.dart';
import 'package:fitness_tracker/data/models/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class FitnessLocalDataSource {
  Future<List<ActivityModel>> getActivities();
  Future<void> saveActivity(ActivityModel activity);
  Future<UserModel?> getUser();
  Future<void> saveUser(UserModel user);
}

class FitnessLocalDataSourceImpl implements FitnessLocalDataSource {
  static const String _activityBox = 'activities';
  static const String _userBox = 'user_data';

  @override
  Future<List<ActivityModel>> getActivities() async {
    final box = Hive.box(_activityBox);
    return box.values.cast<ActivityModel>().toList();
  }

  @override
  Future<void> saveActivity(ActivityModel activity) async {
    final box = Hive.box(_activityBox);
    await box.put(activity.id, activity);
  }

  @override
  Future<UserModel?> getUser() async {
    final box = Hive.box(_userBox);
    if (box.isEmpty) return null;
    return box.get('current_user') as UserModel?;
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final box = Hive.box(_userBox);
    await box.put('current_user', user);
  }
}
