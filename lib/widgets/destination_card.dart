import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/destination.dart';
import '../providers/favorites_provider.dart';
import '../screens/detail_screen.dart';

class DestinationCard extends StatelessWidget {
  const DestinationCard({super.key, required this.destination});

  final Destination destination;

  @override
  Widget build(BuildContext context) {
    final isFav =
        context.watch<FavoritesProvider>().isFavorite(destination.name);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(destination.name),
        subtitle: Text(destination.tagline),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DetailScreen(destination: destination),
          ),
        ),
        trailing: IconButton(
          icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
          color: isFav ? Colors.red : null,
          onPressed: () =>
              context.read<FavoritesProvider>().toggle(destination.name),
        ),
      ),
    );
  }
}