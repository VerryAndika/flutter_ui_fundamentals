import 'package:flutter/material.dart';

import '../../p5/widgets/identity_header.dart';

// Tahap 1: identifikasi state pada Course Explorer.
const List<(String, String, String)> courseExplorerStates = [
  ('Tab terpilih di NavigationBar', 'Local', 'hanya dipakai shell navigasi'),
  ('Teks yang sedang diketik di form', 'Local', 'hanya milik form feedback'),
  ('Expand/collapse info course', 'Local', 'tampilan sementara satu kartu'),
  ('Loading saat kirim feedback', 'Local', 'hanya mengubah tombol kirim'),
  ('Daftar course dari JSON', 'Shared', 'dipakai Home, Courses, Detail'),
  ('Course favorite', 'Shared', 'dipakai list, detail, dan Favorites'),
  ('Identitas mahasiswa', 'Shared', 'tampil di hampir semua screen'),
];

class LocalSharedStatePage extends StatefulWidget {
  const LocalSharedStatePage({super.key});

  @override
  State<LocalSharedStatePage> createState() => _LocalSharedStatePageState();
}

class _LocalSharedStatePageState extends State<LocalSharedStatePage> {
  // Local state: hanya dibutuhkan halaman ini.
  bool showDetail = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('P6 Tahap 1 - Local vs Shared')),
      body: ListView(
        children: [
          const IdentityHeader(subtitle: 'Identifikasi state'),
          for (final (name, kind, reason) in courseExplorerStates)
            ListTile(
              dense: true,
              leading: Chip(
                label: Text(kind),
                backgroundColor: kind == 'Local'
                    ? Colors.orange.shade100
                    : Colors.blue.shade100,
              ),
              title: Text(name),
              subtitle: Text(reason),
            ),
          const Divider(),
          SwitchListTile(
            title: const Text('Tampilkan detail course (local state)'),
            value: showDetail,
            onChanged: (value) => setState(() => showDetail = value),
          ),
          if (showDetail)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('MOB06 - State Management'),
                  subtitle: Text(
                    'Detail ini hanya dibuka/tutup di halaman ini, '
                    'jadi cukup dikelola dengan setState().',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
