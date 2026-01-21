import '../models/game.dart';

class GamesData {
  static const List<Game> games = [
    Game(
      id: 'g1',
      title: 'The Last of Us Part I',
      price: 69.99,
      imageAsset: 'assets/images/last_of_us.jpg',
    ),
    Game(
      id: 'g2',
      title: 'God of War Ragnarök',
      price: 79.99,
      imageAsset: 'assets/images/god_of_war.jpg',
    ),
    Game(
      id: 'g3',
      title: 'Uncharted 4: A Thief’s End',
      price: 29.99,
      imageAsset: 'assets/images/uncharted_4.jpg',
    ),
    Game(
      id: 'g4',
      title: 'Marvel’s Spider-Man',
      price: 49.99,
      imageAsset: 'assets/images/spider_man.jpg',
    ),
  ];

  static final Map<String, Game> byId = {
    for (final g in games) g.id: g,
  };
}
