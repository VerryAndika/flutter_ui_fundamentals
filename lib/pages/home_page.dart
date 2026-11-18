import 'package:flutter/material.dart';

import '../firebase_options.dart';
import '../identity.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../services/profile_service.dart';
import '../widgets/role_guard.dart';
import 'kos_form_page.dart';
import 'kos_list_page.dart';
import 'login_page.dart';
import 'notification_page.dart';
import 'security_test_page.dart';

// P9 Praktik 4: menu dan tombol pada Home berbeda sesuai role.
//   seeker : Daftar Kos, Detail Kos
//   owner  : + My Kos, Tambah Kos
//   admin  : + Kelola Data (Admin)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<UserProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = ProfileService().getMyProfile();
    // P9 Praktik 8-10 + Bonus: permission, token, listener, tap handler.
    if (DefaultFirebaseOptions.isSupported) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await NotificationService.instance.init();
        await NotificationService.instance.setupInteractedMessage();
      });
    }
  }

  Future<void> _logout() async {
    await AuthService.instance.logout(); // Session Removed
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  void _open(Widget page) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile?>(
      future: _profileFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final p = snap.data;
        if (snap.hasError || p == null) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  tooltip: 'Logout',
                  icon: const Icon(Icons.logout),
                  onPressed: _logout,
                ),
              ],
            ),
            body: Center(
              child: TextButton(
                onPressed: () => setState(() {
                  _profileFuture = ProfileService().getMyProfile();
                }),
                child: const Text('Gagal memuat profil. Coba lagi'),
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('KosFinder (${p.role})'),
            actions: [
              IconButton(
                tooltip: 'Logout',
                icon: const Icon(Icons.logout),
                onPressed: _logout,
              ),
            ],
          ),
          body: ListView(
            children: [
              _ProfileCard(profile: p),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.list_alt),
                title: const Text('Daftar Kos'),
                subtitle: const Text('Semua role'),
                onTap: () => _open(KosListPage(isAdmin: p.isAdmin)),
              ),
              if (p.isOwner || p.isAdmin)
                ListTile(
                  leading: const Icon(Icons.home_work),
                  title: const Text('My Kos'),
                  subtitle: const Text('Khusus pemilik kos'),
                  onTap: () => _open(const KosListPage(onlyMine: true)),
                ),
              ListTile(
                leading: const Icon(Icons.notifications_active),
                title: const Text('Push Notification (FCM)'),
                subtitle: const Text('Permission, token, notifikasi diterima'),
                onTap: () => _open(const NotificationPage()),
              ),
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Security Testing (RLS)'),
                subtitle: const Text(
                  'Praktik 6: uji operasi yang harus ditolak',
                ),
                onTap: () => _open(const SecurityTestPage()),
              ),
              if (p.isAdmin)
                ListTile(
                  leading: const Icon(Icons.admin_panel_settings),
                  title: const Text('Kelola Data (Admin)'),
                  onTap: () => _open(const KosListPage(isAdmin: true)),
                ),
            ],
          ),
          // Tombol "Tambah Kos" hanya untuk owner / admin.
          floatingActionButton: RoleGuard(
            role: p.role,
            allowed: const ['owner', 'admin'],
            child: FloatingActionButton.extended(
              onPressed: () => _open(const KosFormPage()),
              icon: const Icon(Icons.add_home),
              label: const Text('Tambah Kos'),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final p = profile;
    return Card(
      margin: const EdgeInsets.all(12),
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              child: Icon(
                p.isOwner
                    ? Icons.home_work
                    : p.isAdmin
                    ? Icons.admin_panel_settings
                    : Icons.search,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name.isEmpty ? '-' : p.name,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(p.email),
                  const SizedBox(height: 4),
                  Chip(
                    avatar: const Icon(Icons.badge, size: 16),
                    label: Text('Role: ${p.roleLabel}'),
                    visualDensity: VisualDensity.compact,
                  ),
                  Text(
                    'P9 • $studentId - $studentName',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
