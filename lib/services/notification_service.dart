import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();

  static FlutterLocalNotificationsPlugin? _plugin;
  static AndroidFlutterLocalNotificationsPlugin? _android;

  static const AndroidNotificationChannel _cartChannel =
      AndroidNotificationChannel(
    'cart_channel',
    'Cart Notifications',
    description: 'Notifications when items are added to cart',
    importance: Importance.high,
  );

  static Future<void> init() async {
    // Create plugin instance once
    _plugin ??= FlutterLocalNotificationsPlugin();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _plugin!.initialize(initSettings);

    _android = _plugin!
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    // Channel required for Android 8+
    await _android?.createNotificationChannel(_cartChannel);

    // Permission required for Android 13+
    await _android?.requestNotificationsPermission();
  }

  static Future<void> showAddedToCart(String gameTitle) async {
    if (_plugin == null) {
      // Safety: if someone calls show before init()
      await init();
    }

    const androidDetails = AndroidNotificationDetails(
      'cart_channel',
      'Cart Notifications',
      channelDescription: 'Notifications when items are added to cart',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin!.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Added to cart',
      '$gameTitle was added to your cart',
      details,
    );
  }
}
