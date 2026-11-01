import 'package:flutter/foundation.dart';

// Tahap 5: state course dipisahkan ke ChangeNotifier.
class CourseProvider extends ChangeNotifier {
  final Set<String> favorites = {};

  int get favoriteCount => favorites.length;

  bool isFavorite(String code) => favorites.contains(code);

  void toggleFavorite(String code) {
    if (favorites.contains(code)) {
      favorites.remove(code);
    } else {
      favorites.add(code);
    }
    notifyListeners();
  }
}
