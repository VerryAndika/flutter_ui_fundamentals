// P9: konfigurasi Firebase project "kosfinder-p9".
//
// Nilai di bawah adalah konfigurasi publik aplikasi web Firebase (bukan
// secret): apiKey Firebase hanya mengidentifikasi project dan dibatasi oleh
// aturan Firebase. Setara dengan file yang dibuat `flutterfire configure`.
// Tidak ada service account / private key di repository.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  /// Hanya platform web yang dikonfigurasi pada praktikum ini
  /// (pengujian push notification memakai Chrome).
  static bool get isSupported => kIsWeb;

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    throw UnsupportedError(
      'Firebase belum dikonfigurasi untuk ${defaultTargetPlatform.name}. '
      'Jalankan `flutterfire configure` untuk Android/iOS.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDP6OOU5reuuDuWx8guX_KnuUCtWDZQ8WI',
    appId: '1:565979094510:web:cf51ee7acc454d663b42ff',
    messagingSenderId: '565979094510',
    projectId: 'kosfinder-p9',
    authDomain: 'kosfinder-p9.firebaseapp.com',
    storageBucket: 'kosfinder-p9.firebasestorage.app',
  );

  /// Public key Web Push (VAPID) dari Firebase Console > Cloud Messaging.
  static const String webVapidKey =
      'BDLHsLgGmKEXw-dr6eO3_f8e4ismNHf0VXcXt9kVv9jx_amXClDzaJ7d9--Z0q6-9eaDzgbdg5cVhQ31v5YALq4';
}
