import 'dart:async';
import 'package:fitness_tracker/data/datasources/local/fitness_local_datasource.dart';
import 'package:fitness_tracker/data/models/activity_model.dart';
import 'package:fitness_tracker/data/models/user_model.dart';
import 'package:fitness_tracker/domain/entities/activity.dart';
import 'package:fitness_tracker/domain/entities/user.dart';
import 'package:fitness_tracker/domain/repositories/fitness_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:health/health.dart';
import 'package:pedometer/pedometer.dart';

class FitnessRepositoryImpl implements FitnessRepository {
  final FitnessLocalDataSource localDataSource;
  final Health health = Health();

  FitnessRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Activity>> getActivities() async {
    return await localDataSource.getActivities();
  }

  @override
  Future<void> saveActivity(Activity activity) async {
    await localDataSource.saveActivity(ActivityModel.fromEntity(activity));
  }

  @override
  Future<User> getUser() async {
    final userModel = await localDataSource.getUser();
    if (userModel != null) return userModel;

    // Default user if none exists
    return const User(
      id: 'default',
      name: 'Fitness Enthusiast',
      weight: 70.0,
      height: 175.0,
      dailyStepGoal: 10000,
      dailyCalorieGoal: 2500,
      streakDays: 0,
    );
  }

  @override
  Future<void> saveUser(User user) async {
    await localDataSource.saveUser(UserModel.fromEntity(user));
  }

  @override
  Stream<int> getStepCount() {
    return Pedometer.stepCountStream.map((event) => event.steps);
  }

  @override
  Stream<double> getLiveDistance() {
    double totalDistance = 0;
    Position? lastPosition;

    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 2,
      ),
    ).map((position) {
      if (lastPosition != null) {
        totalDistance +=
            Geolocator.distanceBetween(
              lastPosition!.latitude,
              lastPosition!.longitude,
              position.latitude,
              position.longitude,
            ) /
            1000; // Convert to km
      }
      lastPosition = position;
      return totalDistance;
    });
  }

  @override
  Future<bool> requestHealthPermissions() async {
    final types = [
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
      HealthDataType.DISTANCE_DELTA,
      HealthDataType.ACTIVE_ENERGY_BURNED,
    ];
    final permissions = [
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
    ];

    try {
      bool? hasPermissions = await health.hasPermissions(
        types,
        permissions: permissions,
      );
      if (hasPermissions != true) {
        hasPermissions = await health.requestAuthorization(
          types,
          permissions: permissions,
        );
      }
      return hasPermissions ?? false;
    } catch (e) {
      print("Health error: $e");
      return false;
    }
  }

  @override
  Future<int> getRecentHealthSteps() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
      types: [HealthDataType.STEPS],
      startTime: midnight,
      endTime: now,
    );

    int totalSteps = 0;
    for (var p in healthData) {
      totalSteps += (p.value as num).toInt();
    }
    return totalSteps;
  }
}
