import 'package:equatable/equatable.dart';

enum ActivityType { walking, running, cycling }

class Activity extends Equatable {
  final String id;
  final ActivityType type;
  final DateTime startTime;
  final DateTime? endTime;
  final int steps;
  final double distance; // in meters
  final double calories;
  final double duration; // in seconds
  final List<List<double>> path; // List of [lat, lng]

  const Activity({
    required this.id,
    required this.type,
    required this.startTime,
    this.endTime,
    required this.steps,
    required this.distance,
    required this.calories,
    required this.duration,
    required this.path,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    startTime,
    endTime,
    steps,
    distance,
    calories,
    duration,
    path,
  ];
}
