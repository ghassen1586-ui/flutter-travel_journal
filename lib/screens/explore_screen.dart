import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/destinations_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/destination_card.dart';
import 'my_trips_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.select<FavoritesProvider, int>((p) => p.count);
    final dest = context.watch<DestinationsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Travel Journal'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MyTripsScreen()),
            ),
            icon: Badge.count(
              count: count,
              isLabelVisible: count > 0,
              child: const Icon(Icons.favorite),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: switch (dest.status) {
        Status.loading => const Center(child: CircularProgressIndicator()),
        Status.error => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Error: ${dest.error}'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.read<DestinationsProvider>().load(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        Status.done => ListView(
            children: [
              for (final d in dest.items) DestinationCard(destination: d),
            ],
          ),
      },
    );
  }
}