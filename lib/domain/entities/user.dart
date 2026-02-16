import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final double weight; // in kg
  final double height; // in cm
  final int dailyStepGoal;
  final double dailyCalorieGoal;
  final int streakDays;

  const User({
    required this.id,
    required this.name,
    required this.weight,
    required this.height,
    required this.dailyStepGoal,
    required this.dailyCalorieGoal,
    required this.streakDays,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    weight,
    height,
    dailyStepGoal,
    dailyCalorieGoal,
    streakDays,
  ];
}
