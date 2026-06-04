import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // 1. Request Notification Permissions (Crucial for iOS & Android 13+)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted notification permissions.');
    }

    // 2. Foreground Listener (App is running in the foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Received foreground message: ${message.notification?.title}');
      // TODO: Integrate flutter_local_notifications here to show a visual banner if needed
    });

    // 3. Background Listener (App is minimized, user clicks notification)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('App opened from background via notification: ${message.notification?.title}');
      // TODO: Handle navigation here if the payload contains specific screen data
    });

    // 4. Terminated Listener (App is completely killed, user clicks notification)
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('App launched from terminated state via notification: ${initialMessage.notification?.title}');
    }
  }
}
