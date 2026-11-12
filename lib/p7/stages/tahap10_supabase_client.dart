import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../config/supabase_config.dart';
import '../../widgets/identity_header.dart';

// Tahap 10: membuktikan Supabase client sudah diinisialisasi di main().
class SupabaseClientPage extends StatelessWidget {
  const SupabaseClientPage({super.key});

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;
    return Scaffold(
      appBar: AppBar(title: const Text('P7 Tahap 10 - Supabase Client')),
      body: ListView(
        children: [
          const IdentityHeader(subtitle: 'Supabase.initialize'),
          const ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text('Supabase client siap'),
            subtitle: Text('Supabase.initialize() dipanggil sebelum runApp()'),
          ),
          const ListTile(
            leading: Icon(Icons.link),
            title: Text('Project URL'),
            subtitle: Text(supabaseUrl),
          ),
          ListTile(
            leading: const Icon(Icons.key),
            title: const Text('Publishable (anon) key — disamarkan'),
            subtitle: Text(maskedSupabaseKey),
          ),
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('REST endpoint client'),
            subtitle: Text(client.rest.url),
          ),
          const ListTile(
            leading: Icon(Icons.shield, color: Colors.orange),
            title: Text('Tidak ada service_role / secret key di aplikasi'),
          ),
        ],
      ),
    );
  }
}
