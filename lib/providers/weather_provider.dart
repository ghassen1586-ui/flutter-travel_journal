import 'package:flutter/foundation.dart';

import '../models/destination.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  final _service = WeatherService();
  final Map<String, Weather> _cache = {};

  Future<Weather> get(Destination d) async {
    final cached = _cache[d.name];
    if (cached != null) return cached; // already loaded → no API call

    final weather = await _service.fetch(d.lat, d.lng);
    _cache[d.name] = weather;
    return weather;
  }
}