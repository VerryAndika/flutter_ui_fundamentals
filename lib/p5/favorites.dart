import 'package:flutter/foundation.dart';

// Kode course favorit, dibagi antar halaman Course Explorer.
final ValueNotifier<Set<String>> favoriteCodes = ValueNotifier(<String>{});

bool isFavorite(String code) => favoriteCodes.value.contains(code);

void setFavorite(String code, bool value) {
  final next = {...favoriteCodes.value};
  value ? next.add(code) : next.remove(code);
  favoriteCodes.value = next;
}
