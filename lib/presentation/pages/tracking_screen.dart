import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fitness_tracker/core/theme/app_theme.dart';
import 'package:fitness_tracker/domain/entities/activity.dart';
import 'package:fitness_tracker/presentation/blocs/activity/activity_bloc.dart';
import 'package:fitness_tracker/presentation/widgets/custom_widgets.dart';

class TrackingScreen extends StatefulWidget {
  final ActivityType type;
  const TrackingScreen({super.key, required this.type});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    context.read<ActivityBloc>().add(StartTracking(widget.type));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [_buildMap(), _buildOverlay(context)]),
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(37.7749, -122.4194), // Placeholder (San Francisco)
        zoom: 16,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      polylines: _polylines,
      onMapCreated: (controller) {},
      style: _mapStyle,
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        if (state is! TrackingInProgress) return const SizedBox();

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        context.read<ActivityBloc>().add(StopTracking());
                        Navigator.pop(context);
                      },
                    ),
                    GlassCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      borderRadius: 12,
                      child: Text(
                        _formatDuration(state.duration),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 40), // Balance
                  ],
                ),
                const Spacer(),
                GlassCard(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(
                            label: 'Distance',
                            value:
                                '${state.currentDistance.toStringAsFixed(2)} km',
                          ),
                          _StatItem(label: 'Pace', value: '5:24 min/km'),
                          _StatItem(
                            label: 'Steps',
                            value: state.currentSteps.toString(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _ControlButton(
                            icon: Icons.pause_rounded,
                            onPressed: () {},
                          ),
                          const SizedBox(width: 24),
                          _ControlButton(
                            icon: Icons.stop_rounded,
                            color: Colors.red,
                            isLarge: true,
                            onPressed: () {
                              context.read<ActivityBloc>().add(StopTracking());
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 24),
                          _ControlButton(
                            icon: Icons.map_rounded,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  final String _mapStyle = '''[
  {
    "elementType": "geometry",
    "stylers": [{"color": "#242f3e"}]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [{"color": "#242f3e"}]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#746855"}]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#d59563"}]
  }
]''';
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(color: AppColors.textBody, fontSize: 12),
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final bool isLarge;

  const _ControlButton({
    required this.icon,
    required this.onPressed,
    this.color,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isLarge ? 80 : 60,
      height: isLarge ? 80 : 60,
      decoration: BoxDecoration(
        color: color ?? AppColors.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (color ?? AppColors.primary).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: isLarge ? 40 : 28),
        onPressed: onPressed,
      ),
    );
  }
}
