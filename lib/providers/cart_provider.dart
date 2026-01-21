import 'package:flutter/foundation.dart';
import '../models/game.dart';

class CartProvider extends ChangeNotifier {
  final List<Game> _items = [];

  List<Game> get items => List.unmodifiable(_items);

  double get totalPrice => _items.fold(0.0, (sum, g) => sum + g.price);

  void add(Game game) {
    _items.add(game);
    notifyListeners();
  }

  void remove(Game game) {
    _items.remove(game);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
