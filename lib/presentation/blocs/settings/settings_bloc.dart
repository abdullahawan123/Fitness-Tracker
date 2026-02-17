import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_tracker/domain/entities/settings.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Events
abstract class SettingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {}

class ToggleDarkMode extends SettingsEvent {
  final bool isDark;
  ToggleDarkMode(this.isDark);
  @override
  List<Object?> get props => [isDark];
}

class ToggleUnits extends SettingsEvent {
  final bool isMetric;
  ToggleUnits(this.isMetric);
  @override
  List<Object?> get props => [isMetric];
}

// State
class SettingsState extends Equatable {
  final AppSettings settings;
  const SettingsState(this.settings);
  @override
  List<Object?> get props => [settings];
}

// Bloc
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final Box _box = Hive.box('settings');

  SettingsBloc() : super(const SettingsState(AppSettings())) {
    on<LoadSettings>((event, emit) {
      final isDark = _box.get('isDarkMode', defaultValue: true);
      final isMetric = _box.get('useMetricUnits', defaultValue: true);
      final notifs = _box.get('notificationsEnabled', defaultValue: true);

      emit(
        SettingsState(
          AppSettings(
            isDarkMode: isDark,
            useMetricUnits: isMetric,
            notificationsEnabled: notifs,
          ),
        ),
      );
    });

    on<ToggleDarkMode>((event, emit) async {
      await _box.put('isDarkMode', event.isDark);
      emit(SettingsState(state.settings.copyWith(isDarkMode: event.isDark)));
    });

    on<ToggleUnits>((event, emit) async {
      await _box.put('useMetricUnits', event.isMetric);
      emit(
        SettingsState(state.settings.copyWith(useMetricUnits: event.isMetric)),
      );
    });
  }
}
