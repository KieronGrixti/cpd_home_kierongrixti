import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game.dart';
import '../providers/cart_provider.dart';

import 'profile_screen.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  static const games = <Game>[
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

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Store'),
        actions: [
          IconButton(
            tooltip: 'Profile',
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                'Cart: ${cart.items.length}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: games.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75, // uniform card size
          ),
          itemBuilder: (context, index) => _GameCard(game: games[index]),
        ),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final Game game;
  const _GameCard({required this.game});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    final cs = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      color: const Color(0xFFF7FAFF), // very light blue-ish white
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // FIXED image area using AspectRatio (consistent look)
          AspectRatio(
            aspectRatio: 16 / 10, // fixed image height relative to card width
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    game.imageAsset,
                    fit: BoxFit.cover,
                  ),
                ),
                // price badge
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '€${game.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Title area (fixed height so cards stay equal)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
            child: SizedBox(
              height: 42, // keeps layout consistent
              child: Center(
                child: Text(
                  game.title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),

          const Spacer(), // pushes button to bottom

          // Button pinned at bottom
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => cart.add(game),
                style: FilledButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
