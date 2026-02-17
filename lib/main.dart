import 'package:fitness_tracker/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_tracker/core/theme/app_theme.dart';
import 'package:fitness_tracker/core/utils/service_locator.dart' as di;
import 'package:fitness_tracker/presentation/blocs/activity/activity_bloc.dart';
import 'package:fitness_tracker/presentation/blocs/user/user_bloc.dart';
import 'package:fitness_tracker/presentation/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:fitness_tracker/presentation/blocs/settings/settings_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await di.init();

  // Lock orientation
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Transparent status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<ActivityBloc>()..add(LoadActivities()),
        ),
        BlocProvider(create: (_) => di.sl<UserBloc>()..add(LoadUser())),
        BlocProvider(create: (_) => di.sl<SettingsBloc>()..add(LoadSettings())),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'FitTrack Pro',
            debugShowCheckedModeBanner: false,
            theme: state.settings.isDarkMode
                ? AppTheme.darkTheme
                : AppTheme.lightTheme,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
