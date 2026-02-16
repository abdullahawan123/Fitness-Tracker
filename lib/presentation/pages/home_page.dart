import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:fitness_tracker/core/theme/app_theme.dart';
import 'package:fitness_tracker/presentation/pages/dashboard_screen.dart';
import 'package:fitness_tracker/presentation/pages/analytics_screen.dart';
import 'package:fitness_tracker/presentation/pages/achievements_screen.dart';
import 'package:fitness_tracker/presentation/pages/profile_screen.dart';
import 'package:fitness_tracker/presentation/pages/tracking_screen.dart';
import 'package:fitness_tracker/domain/entities/activity.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const AnalyticsScreen(),
    const AchievementsScreen(),
    const ProfileScreen(),
  ];

  final List<IconData> _iconList = [
    Icons.dashboard_rounded,
    Icons.bar_chart_rounded,
    Icons.emoji_events_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_bottomNavIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const TrackingScreen(type: ActivityType.running),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.play_arrow_rounded,
          size: 36,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: _iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        backgroundColor: AppColors.surface,
        activeColor: AppColors.primary,
        inactiveColor: AppColors.textBody,
      ),
    );
  }
}
