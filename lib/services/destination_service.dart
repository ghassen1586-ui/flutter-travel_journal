import 'dart:math';

import '../models/destination.dart';

class DestinationService {
  Future<List<Destination>> fetchAll() async {
    await Future.delayed(const Duration(seconds: 2)); // fake network
    if (Random().nextBool()) throw Exception('No internet'); // fails 1 in 2
    return destinations;
  }
}