import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fitness_tracker/data/datasources/local/fitness_local_datasource.dart';
import 'package:fitness_tracker/domain/repositories/fitness_repository.dart';
import 'package:fitness_tracker/data/repositories/fitness_repository_impl.dart';
import 'package:fitness_tracker/presentation/blocs/activity/activity_bloc.dart';
import 'package:fitness_tracker/presentation/blocs/user/user_bloc.dart';
import 'package:fitness_tracker/presentation/blocs/settings/settings_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('activities');
  await Hive.openBox('user_data');

  // Bloc
  sl.registerFactory(() => ActivityBloc(repository: sl()));
  sl.registerFactory(() => UserBloc(repository: sl()));
  sl.registerFactory(() => SettingsBloc());

  // Use cases (TBD)

  // Repository
  sl.registerLazySingleton<FitnessRepository>(
    () => FitnessRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<FitnessLocalDataSource>(
    () => FitnessLocalDataSourceImpl(),
  );
}
