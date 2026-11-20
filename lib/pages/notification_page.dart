import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../identity.dart';
import '../services/notification_service.dart';

// P9 Praktik 8–10: status permission, token FCM (disensor), registrasi
// device, dan log notifikasi yang diterima saat aplikasi terbuka.
class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  static String mask(String t) =>
      t.length <= 24 ? t : '${t.substring(0, 16)}…${t.substring(t.length - 8)}';

  @override
  Widget build(BuildContext context) {
    final n = NotificationService.instance;
    return ListenableBuilder(
      listenable: n,
      builder: (context, _) {
        final status = n.permission;
        final granted =
            status == AuthorizationStatus.authorized ||
            status == AuthorizationStatus.provisional;
        return Scaffold(
          appBar: AppBar(title: const Text('Push Notification (FCM)')),
          body: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              const Text('P9 • $studentId - $studentName'),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: n.init,
                icon: const Icon(Icons.notifications),
                label: const Text('Aktifkan notifikasi (permission + token)'),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: Icon(
                    granted
                        ? Icons.notifications_active
                        : Icons.notifications_off,
                    color: granted ? Colors.green : Colors.orange,
                  ),
                  title: const Text('Status permission'),
                  subtitle: Text(status?.name ?? 'belum diminta'),
                  trailing: TextButton(
                    onPressed: n.requestPermission,
                    child: const Text('Minta izin'),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.key),
                  title: const Text('FCM token (disensor)'),
                  subtitle: Text(n.token == null ? '-' : mask(n.token!)),
                  trailing: n.token == null
                      ? TextButton(
                          onPressed: n.getToken,
                          child: const Text('Ambil token'),
                        )
                      : IconButton(
                          tooltip: 'Salin token lengkap',
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: n.token!));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Token disalin')),
                            );
                          },
                        ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(
                    n.tokenSaved ? Icons.cloud_done : Icons.cloud_off,
                    color: n.tokenSaved ? Colors.green : null,
                  ),
                  title: const Text('Device registration'),
                  subtitle: Text(
                    n.tokenSaved
                        ? 'Token tersimpan di tabel device_tokens (Supabase)'
                        : 'Belum tersimpan',
                  ),
                ),
              ),
              if (n.error != null)
                Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: ListTile(
                    leading: const Icon(Icons.error_outline),
                    title: const Text('Error FCM'),
                    subtitle: Text(n.error!),
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                'Notifikasi diterima (foreground)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (n.received.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Belum ada. Kirim test message dari Firebase Console.',
                  ),
                ),
              for (final r in n.received)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.notifications),
                    title: Text(r.title),
                    subtitle: Text(
                      '${r.body}\n${TimeOfDay.fromDateTime(r.at).format(context)}'
                      '${r.data.isEmpty ? '' : ' • data: ${r.data}'}',
                    ),
                    isThreeLine: true,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
