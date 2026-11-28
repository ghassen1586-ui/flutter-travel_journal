import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather.dart';

class WeatherService {
  Future<Weather> fetch(double lat, double lng) async {
    final url = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '$lat',
      'longitude': '$lng',
      'current': 'temperature_2m,weather_code,wind_speed_10m',
    });

    final res = await http.get(url).timeout(const Duration(seconds: 10));

    if (res.statusCode != 200) {
      throw Exception('Server error ${res.statusCode}');
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return Weather.fromJson(json);
  }
}