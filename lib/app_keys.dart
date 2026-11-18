import 'package:flutter/material.dart';

/// P9 Praktik 2: key global agar navigasi/snackbar bisa dipanggil dari luar
/// widget (listener auth, notifikasi FCM).
final navigatorKey = GlobalKey<NavigatorState>();
final messengerKey = GlobalKey<ScaffoldMessengerState>();
