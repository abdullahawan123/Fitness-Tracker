import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_tracker/domain/entities/activity.dart';
import 'package:fitness_tracker/domain/repositories/fitness_repository.dart';

// Events
abstract class ActivityEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadActivities extends ActivityEvent {}

class StartTracking extends ActivityEvent {
  final ActivityType type;
  StartTracking(this.type);
}

class StopTracking extends ActivityEvent {}

class UpdateLiveStats extends ActivityEvent {
  final int steps;
  final double distance;
  UpdateLiveStats(this.steps, this.distance);
}

// State
abstract class ActivityState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ActivityInitial extends ActivityState {}

class ActivityLoading extends ActivityState {}

class ActivitiesLoaded extends ActivityState {
  final List<Activity> activities;
  final int todaySteps;
  final double todayDistance;
  final double todayCalories;

  ActivitiesLoaded(
    this.activities,
    this.todaySteps,
    this.todayDistance,
    this.todayCalories,
  );

  @override
  List<Object?> get props => [
    activities,
    todaySteps,
    todayDistance,
    todayCalories,
  ];
}

class TrackingInProgress extends ActivityState {
  final ActivityType type;
  final int currentSteps;
  final double currentDistance;
  final Duration duration;

  TrackingInProgress({
    required this.type,
    this.currentSteps = 0,
    this.currentDistance = 0,
    this.duration = Duration.zero,
  });

  @override
  List<Object?> get props => [type, currentSteps, currentDistance, duration];
}

// Bloc
class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final FitnessRepository repository;
  StreamSubscription? _stepSubscription;
  Timer? _timer;

  ActivityBloc({required this.repository}) : super(ActivityInitial()) {
    on<LoadActivities>(_onLoadActivities);
    on<StartTracking>(_onStartTracking);
    on<UpdateLiveStats>(_onUpdateLiveStats);
    on<StopTracking>(_onStopTracking);
  }

  Future<void> _onLoadActivities(
    LoadActivities event,
    Emitter<ActivityState> emit,
  ) async {
    emit(ActivityLoading());
    try {
      final activities = await repository.getActivities();
      final healthSteps = await repository.getRecentHealthSteps();

      // Calculate today's stats from activities if health API is limited
      double totalDist = 0;
      double totalCals = 0;
      for (var a in activities) {
        if (a.startTime.day == DateTime.now().day) {
          totalDist += a.distance;
          totalCals += a.calories;
        }
      }

      emit(ActivitiesLoaded(activities, healthSteps, totalDist, totalCals));
    } catch (e) {
      emit(ActivitiesLoaded(const [], 0, 0, 0));
    }
  }

  StreamSubscription? _distanceSubscription;
  int _initialSteps = 0;

  void _onStartTracking(StartTracking event, Emitter<ActivityState> emit) {
    emit(TrackingInProgress(type: event.type));
    _initialSteps = 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state is TrackingInProgress) {
        final s = state as TrackingInProgress;
        add(UpdateLiveStats(s.currentSteps, s.currentDistance));
      }
    });

    _stepSubscription = repository.getStepCount().listen((steps) {
      if (_initialSteps == 0 && steps > 0) _initialSteps = steps;

      if (state is TrackingInProgress) {
        final s = state as TrackingInProgress;
        final workoutSteps = steps - _initialSteps;
        add(
          UpdateLiveStats(
            workoutSteps > 0 ? workoutSteps : 0,
            s.currentDistance,
          ),
        );
      }
    });

    _distanceSubscription = repository.getLiveDistance().listen((distance) {
      if (state is TrackingInProgress) {
        final s = state as TrackingInProgress;
        add(UpdateLiveStats(s.currentSteps, distance));
      }
    });
  }

  void _onUpdateLiveStats(UpdateLiveStats event, Emitter<ActivityState> emit) {
    if (state is TrackingInProgress) {
      final s = state as TrackingInProgress;
      emit(
        TrackingInProgress(
          type: s.type,
          currentSteps: event.steps,
          currentDistance: event.distance,
          duration: s.duration + const Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _onStopTracking(
    StopTracking event,
    Emitter<ActivityState> emit,
  ) async {
    if (state is TrackingInProgress) {
      final s = state as TrackingInProgress;
      // Save activity (simplified)
      await repository.saveActivity(
        Activity(
          id: DateTime.now().toString(),
          type: s.type,
          startTime: DateTime.now().subtract(s.duration),
          endTime: DateTime.now(),
          steps: s.currentSteps,
          distance: s.currentDistance,
          calories: s.currentSteps * 0.04,
          duration: s.duration.inSeconds.toDouble(),
          path: const [],
        ),
      );
    }
    _stepSubscription?.cancel();
    _distanceSubscription?.cancel();
    _timer?.cancel();
    add(LoadActivities());
  }

  @override
  Future<void> close() {
    _stepSubscription?.cancel();
    _timer?.cancel();
    return super.close();
  }
}
