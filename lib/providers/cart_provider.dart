import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/games_data.dart';
import '../models/game.dart';

class CartProvider extends ChangeNotifier {
  final List<Game> _items = [];

  List<Game> get items => List.unmodifiable(_items);

  double get totalPrice => _items.fold(0.0, (sum, g) => sum + g.price);

  static const _cartKey = 'cart_game_ids';

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_cartKey) ?? [];

    _items
      ..clear()
      ..addAll(
        ids.map((id) => GamesData.byId[id]).whereType<Game>(),
      );

    notifyListeners();
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = _items.map((g) => g.id).toList();
    await prefs.setStringList(_cartKey, ids);
  }

  Future<void> add(Game game) async {
    _items.add(game);
    await _saveCart();
    notifyListeners();
  }

  Future<void> remove(Game game) async {
    _items.remove(game);
    await _saveCart();
    notifyListeners();
  }

  Future<void> clear() async {
    _items.clear();
    await _saveCart();
    notifyListeners();
  }
}
