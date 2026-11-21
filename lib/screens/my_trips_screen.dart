import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';

class MyTripsScreen extends StatelessWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>().all;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear all',
            onPressed: () => context.read<FavoritesProvider>().clear(),
          ),
        ],
      ),
      body: favorites.isEmpty
          ? const Center(child: Text('No trips yet'))
          : ListView(
              children: [
                for (final name in favorites)
                  ListTile(
                    title: Text(name),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite),
                      color: Colors.red,
                      onPressed: () =>
                          context.read<FavoritesProvider>().toggle(name),
                    ),
                  ),
              ],
            ),
    );
  }
}