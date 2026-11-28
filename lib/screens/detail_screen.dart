import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/country.dart';
import '../models/destination.dart';
import '../models/weather.dart';
import '../providers/weather_provider.dart';
import '../services/country_service.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.destination});

  final Destination destination;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<Weather> _weather;
  late Future<Country> _country;

  @override
  void initState() {
    super.initState();
    // Created ONCE here, never in build()
    _weather = context.read<WeatherProvider>().get(widget.destination);
    _country = CountryService().fetchTunisia();
  }

  // Exercise 2: Retry
  void _retry() {
    setState(() {
      _weather = context.read<WeatherProvider>().get(widget.destination);
    });
  }

  // Exercise 3: friendlier errors
  String _errorMessage(Object? error) {
    if (error is TimeoutException) return 'Check your connection';
    return 'Could not load the weather';
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.destination;

    return Scaffold(
      appBar: AppBar(title: Text(d.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bonus 6: country header
            FutureBuilder<Country>(
              future: _country,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const LinearProgressIndicator();
                }
                if (snapshot.hasError) {
                  return const Text('Country info unavailable');
                }
                final c = snapshot.data!;
                return Text(
                  '${c.name} · Capital: ${c.capital} · Population: ${c.population}',
                  style: const TextStyle(color: Colors.grey),
                );
              },
            ),
            const SizedBox(height: 16),

            // Weather card
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: FutureBuilder<Weather>(
                    future: _weather,
                    builder: (context, snapshot) {
                      // Loading
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // Error
                      if (snapshot.hasError) {
                        return Column(
                          children: [
                            Text(_errorMessage(snapshot.error)),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _retry,
                              child: const Text('Retry'),
                            ),
                          ],
                        );
                      }

                      // Data
                      final w = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(w.icon, size: 36),
                              const SizedBox(width: 12),
                              Text(
                                '${w.temperature} °C',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(w.label, style: const TextStyle(fontSize: 18)),
                          const SizedBox(height: 4),
                          Text('Wind ${w.windSpeed} km/h'),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(d.tagline, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}