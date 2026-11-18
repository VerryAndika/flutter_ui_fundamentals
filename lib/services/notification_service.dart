import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../app_keys.dart';
import '../firebase_options.dart';
import '../pages/kos_detail_page.dart';

// P9 Praktik 10: handler BACKGROUND / TERMINATED harus fungsi top-level.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('[BACKGROUND] ${message.notification?.title}');
  debugPrint('[BACKGROUND] ${message.notification?.body}');
}

/// Satu notifikasi yang diterima saat aplikasi terbuka (untuk log di UI).
class ReceivedNotification {
  ReceivedNotification(this.title, this.body, this.data, this.at);
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final DateTime at;
}

// P9 Praktik 8–11: permission, token FCM, registrasi device, listener.
class NotificationService extends ChangeNotifier {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  AuthorizationStatus? permission;
  String? token;
  String? error;
  bool tokenSaved = false;
  final received = <ReceivedNotification>[];
  bool _initialized = false;

  // ---------- Praktik 8: Notification Permission ----------
  /// authorized | provisional | denied | notDetermined
  Future<AuthorizationStatus> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    permission = settings.authorizationStatus;
    debugPrint('Notification permission: ${permission!.name}');
    notifyListeners();
    return permission!;
  }

  // ---------- Praktik 9: FCM Token ----------
  Future<String?> getToken() async {
    // Web wajib memakai VAPID key (Web Push certificate dari Firebase).
    // ignore: deprecated_member_use
    token = await _messaging.getToken(
      vapidKey: kIsWeb ? DefaultFirebaseOptions.webVapidKey : null,
    );
    debugPrint('FCM Token: $token');
    notifyListeners();
    return token;
  }

  /// Token dapat berubah, sehingga perubahan perlu didengarkan.
  void listenTokenRefresh(void Function(String token) onRefresh) {
    // ignore: deprecated_member_use
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM Token diperbarui');
      token = newToken;
      notifyListeners();
      onRefresh(newToken);
    });
  }

  /// Device registration: simpan token ke tabel device_tokens (RLS: milik sendiri).
  Future<void> saveTokenToSupabase(String token) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    await Supabase.instance.client.from('device_tokens').upsert({
      'token': token,
      'user_id': user.id,
      'platform': kIsWeb ? 'web' : defaultTargetPlatform.name,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
    tokenSaved = true;
    notifyListeners();
  }

  // ---------- Praktik 10: Menerima Notification ----------
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    try {
      final status = await requestPermission();
      if (status == AuthorizationStatus.denied) return;
      final t = await getToken();
      if (t != null) await saveTokenToSupabase(t);
      listenTokenRefresh(saveTokenToSupabase);

      // iOS: tampilkan banner saat aplikasi di foreground.
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // FOREGROUND: aplikasi sedang terbuka.
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('[FOREGROUND] Notification received');
        debugPrint('title: ${message.notification?.title}');
        debugPrint('body : ${message.notification?.body}');
        debugPrint('data : ${message.data}');
        final title = message.notification?.title ?? 'Notifikasi';
        final body = message.notification?.body ?? '';
        received.insert(
          0,
          ReceivedNotification(title, body, message.data, DateTime.now()),
        );
        notifyListeners();
        // Foreground tidak otomatis tampil sebagai notifikasi sistem,
        // jadi tampilkan sendiri di dalam aplikasi.
        messengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('🔔 $title\n$body'),
            duration: const Duration(seconds: 6),
          ),
        );
      });
    } catch (e) {
      error = '$e';
      debugPrint('FCM error: $e');
      notifyListeners();
    }
  }

  // ---------- Bonus: Notification Interaction ----------
  Future<void> setupInteractedMessage() async {
    // Aplikasi TERMINATED lalu dibuka dari notifikasi.
    final initial = await _messaging.getInitialMessage();
    if (initial != null) _handleTap(initial);
    // Aplikasi BACKGROUND lalu dibuka dari notifikasi.
    FirebaseMessaging.onMessageOpenedApp.listen(_handleTap);
  }

  void _handleTap(RemoteMessage message) {
    final kosId = message.data['kos_id'];
    if (kosId == null) return;
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => KosDetailPage(kosId: kosId.toString())),
    );
  }
}
