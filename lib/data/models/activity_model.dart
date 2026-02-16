import 'package:fitness_tracker/domain/entities/activity.dart';
import 'package:hive/hive.dart';

part 'activity_model.g.dart';

@HiveType(typeId: 0)
class ActivityModel extends Activity {
  @override
  @HiveField(0)
  final String id;
  @HiveField(1)
  final int typeIndex;
  @override
  @HiveField(2)
  final DateTime startTime;
  @override
  @HiveField(3)
  final DateTime? endTime;
  @override
  @HiveField(4)
  final int steps;
  @override
  @HiveField(5)
  final double distance;
  @override
  @HiveField(6)
  final double calories;
  @override
  @HiveField(7)
  final double duration;
  @override
  @HiveField(8)
  final List<List<double>> path;

  ActivityModel({
    required this.id,
    required this.typeIndex,
    required this.startTime,
    this.endTime,
    required this.steps,
    required this.distance,
    required this.calories,
    required this.duration,
    required this.path,
  }) : super(
         id: id,
         type: ActivityType.values[typeIndex],
         startTime: startTime,
         endTime: endTime,
         steps: steps,
         distance: distance,
         calories: calories,
         duration: duration,
         path: path,
       );

  factory ActivityModel.fromEntity(Activity entity) {
    return ActivityModel(
      id: entity.id,
      typeIndex: entity.type.index,
      startTime: entity.startTime,
      endTime: entity.endTime,
      steps: entity.steps,
      distance: entity.distance,
      calories: entity.calories,
      duration: entity.duration,
      path: entity.path,
    );
  }
}
