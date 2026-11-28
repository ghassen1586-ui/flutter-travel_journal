import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/country.dart';

class CountryService {
  Future<Country> fetchTunisia() async {
    final url = Uri.https('restcountries.com', '/v3.1/alpha/tn');

    final res = await http.get(url).timeout(const Duration(seconds: 10));

    if (res.statusCode != 200) {
      throw Exception('Server error ${res.statusCode}');
    }

    final decoded = jsonDecode(res.body);
    // The API can return a list [ {...} ] or a single object { ... }
    final json = decoded is List
        ? decoded.first as Map<String, dynamic>
        : decoded as Map<String, dynamic>;

    return Country.fromJson(json);
  }
}