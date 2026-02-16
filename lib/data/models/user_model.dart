import 'package:fitness_tracker/domain/entities/user.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends User {
  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final double weight;
  @override
  @HiveField(3)
  final double height;
  @override
  @HiveField(4)
  final int dailyStepGoal;
  @override
  @HiveField(5)
  final double dailyCalorieGoal;
  @override
  @HiveField(6)
  final int streakDays;

  const UserModel({
    required this.id,
    required this.name,
    required this.weight,
    required this.height,
    required this.dailyStepGoal,
    required this.dailyCalorieGoal,
    required this.streakDays,
  }) : super(
         id: id,
         name: name,
         weight: weight,
         height: height,
         dailyStepGoal: dailyStepGoal,
         dailyCalorieGoal: dailyCalorieGoal,
         streakDays: streakDays,
       );

  factory UserModel.fromEntity(User entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      weight: entity.weight,
      height: entity.height,
      dailyStepGoal: entity.dailyStepGoal,
      dailyCalorieGoal: entity.dailyCalorieGoal,
      streakDays: entity.streakDays,
    );
  }
}
