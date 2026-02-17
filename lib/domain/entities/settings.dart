import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final bool isDarkMode;
  final bool useMetricUnits; // true for km/kg, false for miles/lbs
  final bool notificationsEnabled;

  const AppSettings({
    this.isDarkMode = true,
    this.useMetricUnits = true,
    this.notificationsEnabled = true,
  });

  AppSettings copyWith({
    bool? isDarkMode,
    bool? useMetricUnits,
    bool? notificationsEnabled,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      useMetricUnits: useMetricUnits ?? this.useMetricUnits,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  List<Object?> get props => [isDarkMode, useMetricUnits, notificationsEnabled];
}
