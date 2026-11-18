import 'package:flutter/material.dart';

import '../identity.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../widgets/role_guard.dart';
import 'login_page.dart';

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
  }

  Future<void> _logout() async {
    await AuthService.instance.logout(); // Session Removed
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  void _soon(String feature) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$feature: segera')));

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
                onTap: () => _soon('Daftar Kos'),
              ),
              if (p.isOwner || p.isAdmin)
                ListTile(
                  leading: const Icon(Icons.home_work),
                  title: const Text('My Kos'),
                  subtitle: const Text('Khusus pemilik kos'),
                  onTap: () => _soon('My Kos'),
                ),
              if (p.isAdmin)
                ListTile(
                  leading: const Icon(Icons.admin_panel_settings),
                  title: const Text('Kelola Data (Admin)'),
                  onTap: () => _soon('Kelola Data'),
                ),
            ],
          ),
          // Tombol "Tambah Kos" hanya untuk owner / admin.
          floatingActionButton: RoleGuard(
            role: p.role,
            allowed: const ['owner', 'admin'],
            child: FloatingActionButton.extended(
              onPressed: () => _soon('Tambah Kos'),
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
