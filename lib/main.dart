import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/destinations_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/weather_provider.dart';
import 'screens/explore_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => DestinationsProvider()..load()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: const TravelJournalApp(),
    ),
  );
}

class TravelJournalApp extends StatelessWidget {
  const TravelJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Journal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal),
      home: const ExploreScreen(),
    );
  }
}