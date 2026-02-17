import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_tracker/core/theme/app_theme.dart';
import 'package:fitness_tracker/presentation/blocs/user/user_bloc.dart';
import 'package:fitness_tracker/presentation/widgets/custom_widgets.dart';
import 'package:fitness_tracker/presentation/blocs/settings/settings_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is! UserLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = state.user;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      'https://api.dicebear.com/7.x/avataaars/svg?seed=Felix',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Text(
                    'Member since Feb 2026',
                    style: TextStyle(color: AppColors.textBody),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildProfileStat('Weight', '${user.weight} kg'),
                      _buildProfileStat('Height', '${user.height} cm'),
                      _buildProfileStat('Goal', '${user.dailyStepGoal} steps'),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _buildMenuSection(context, 'Account Settings', [
                    _MenuItem(
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                    ),
                    _MenuItem(
                      icon: Icons.notifications_none,
                      title: 'Notifications',
                    ),
                    _MenuItem(icon: Icons.lock_outline, title: 'Privacy'),
                  ]),
                  const SizedBox(height: 24),
                  BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, settingsState) {
                      return _buildMenuSection(context, 'Preferences', [
                        _MenuItem(
                          icon: Icons.dark_mode_outlined,
                          title: 'Dark Mode',
                          trailing: Switch(
                            value: settingsState.settings.isDarkMode,
                            onChanged: (val) {
                              context.read<SettingsBloc>().add(
                                ToggleDarkMode(val),
                              );
                            },
                          ),
                        ),
                        _MenuItem(
                          icon: Icons.height,
                          title: 'Units',
                          trailing: Text(
                            settingsState.settings.useMetricUnits
                                ? 'Metric'
                                : 'Imperial',
                          ),
                          onPressed: () {
                            context.read<SettingsBloc>().add(
                              ToggleUnits(
                                !settingsState.settings.useMetricUnits,
                              ),
                            );
                          },
                        ),
                      ]);
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildMenuSection(context, 'More', [
                    _MenuItem(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                    ),
                    _MenuItem(icon: Icons.info_outline, title: 'About App'),
                  ]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(
          label,
          style: const TextStyle(color: AppColors.textBody, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildMenuSection(
    BuildContext context,
    String title,
    List<Widget> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textBody,
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          padding: EdgeInsets.zero,
          child: Column(children: items),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onPressed;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 20),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing:
          trailing ??
          const Icon(Icons.chevron_right, color: AppColors.textBody, size: 20),
      onTap: onPressed ?? () {},
    );
  }
}
