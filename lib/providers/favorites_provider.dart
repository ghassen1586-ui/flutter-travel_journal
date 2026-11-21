import 'package:flutter/foundation.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _names = {};

  List<String> get all => _names.toList();
  int get count => _names.length;

  bool isFavorite(String name) => _names.contains(name);

  void toggle(String name) {
    if (_names.contains(name)) {
      _names.remove(name);
    } else {
      _names.add(name);
    }
    notifyListeners();
  }

  void clear() {
    _names.clear();
    notifyListeners();
  }
}