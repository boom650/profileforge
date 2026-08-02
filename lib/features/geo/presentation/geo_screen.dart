import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/geo/application/geo_providers.dart';

class GeoScreen extends ConsumerWidget {
  const GeoScreen({super.key, required this.lat, required this.lng, this.radiusKm = 25});
  final double lat;
  final double lng;
  final double radiusKm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearby = ref.watch(nearbyOpportunitiesProvider((
      lat: lat,
      lng: lng,
      radiusKm: radiusKm,
    )));
    final engine = ref.watch(geoEngineProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Discover')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Map view requires a Google Maps API key (TODO). '
                'Showing distance-ranked opportunities:'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: nearby.length,
              itemBuilder: (context, i) {
                final o = nearby[i];
                final km = engine.distanceKm(lat, lng, o.lat, o.lng);
                final min = engine.travelMinutes(lat, lng, o.lat, o.lng);
                return Semantics(
                  label: '${o.title}, ${o.category}, ${km.toStringAsFixed(1)} km, '
                      '${min} min travel${o.verified ? ', verified' : ''}',
                  child: ListTile(
                    leading: Tooltip(
                      message: o.category,
                      child: Icon(_iconFor(o.category)),
                    ),
                    title: Text(o.title),
                    subtitle: Text('${o.category} · ${km.toStringAsFixed(1)} km · $min min'),
                    trailing: Tooltip(
                      message: o.verified ? 'Verified opportunity' : 'Unverified — verify before applying',
                      child: o.verified
                          ? const Icon(Icons.verified, color: Colors.green)
                          : const Icon(Icons.pending, color: Colors.orange),
                    ),
                  ),
                ).animate().fadeIn(delay: (i * 40).ms).slideX(begin: 0.1);
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String c) => switch (c) {
        'library' => Icons.menu_book,
        'hackathon' => Icons.code,
        'volunteer' => Icons.volunteer_activism,
        'seminar' => Icons.campaign,
        'competition' => Icons.emoji_events,
        'internship' => Icons.work,
        'museum' => Icons.museum,
        'lab' => Icons.science,
        _ => Icons.place,
      };
}
