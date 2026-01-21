import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  AnalyticsService._();

  static final FirebaseAnalytics _a = FirebaseAnalytics.instance;

  static Future<void> logOpenProfile() => _a.logEvent(
        name: 'open_profile',
      );

  static Future<void> logAddToCart({
    required String gameId,
    required String title,
    required double price,
  }) =>
      _a.logAddToCart(
        items: [
          AnalyticsEventItem(
            itemId: gameId,
            itemName: title,
            price: price,
            currency: 'EUR',
          ),
        ],
        currency: 'EUR',
        value: price,
      );

  static Future<void> logRemoveFromCart({
    required String gameId,
    required String title,
    required double price,
  }) =>
      _a.logRemoveFromCart(
        items: [
          AnalyticsEventItem(
            itemId: gameId,
            itemName: title,
            price: price,
            currency: 'EUR',
          ),
        ],
        currency: 'EUR',
        value: price,
      );

  static Future<void> logClearCart({
    required int itemCount,
    required double totalValue,
  }) =>
      _a.logEvent(
        name: 'clear_cart',
        parameters: {
          'item_count': itemCount,
          'value': totalValue,
          'currency': 'EUR',
        },
      );
}
