import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'providers/cart_provider.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/store_screen.dart';
import 'services/notification_service.dart';
import 'services/analytics_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await NotificationService.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) {
        final cart = CartProvider();
        cart.loadCart(); // loads saved cart from SharedPreferences
        return cart;
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const _titleStyle = TextStyle(
    fontWeight: FontWeight.w900,
    letterSpacing: 0.2,
    shadows: [
      Shadow(
        blurRadius: 6,
        offset: Offset(0, 2),
        color: Color(0x22000000),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final cs = ColorScheme.fromSeed(seedColor: Colors.blue);

    return MaterialApp(
      title: 'Video Game Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: cs,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: cs.primary,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: _titleStyle.copyWith(
            fontSize: 22,
            color: cs.primary,
          ),
        ),
      ),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final _screens = const [
    StoreScreen(),
    CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cartCount = context.watch<CartProvider>().items.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(_index == 0 ? 'Game Store' : 'Cart'),
        actions: _index == 0
            ? [
                IconButton(
                  tooltip: 'Profile',
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    AnalyticsService.logOpenProfile();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        tooltip: 'Open cart',
                        icon: const Icon(Icons.shopping_cart_outlined),
                        onPressed: () => setState(() => _index = 1),
                      ),
                      if (cartCount > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: cs.primary,
                              borderRadius: BorderRadius.circular(999),
                              border:
                                  Border.all(color: Colors.white, width: 2),
                            ),
                            child: Text(
                              '$cartCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ]
            : [],
      ),
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: cs.primary.withOpacity(0.15),
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.store), label: 'Store'),
          NavigationDestination(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        ],
      ),
    );
  }
}
