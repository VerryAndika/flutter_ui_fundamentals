import 'package:flutter/material.dart';

import '../models/kos.dart';
import '../services/kos_service.dart';

// Detail kos berdasarkan id (dipakai dari daftar kos dan dari notifikasi).
class KosDetailPage extends StatelessWidget {
  const KosDetailPage({super.key, required this.kosId});

  final String kosId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Kos')),
      body: FutureBuilder<Kos?>(
        future: KosService().fetchById(kosId),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final kos = snap.data;
          if (snap.hasError || kos == null) {
            return Center(child: Text('Kos tidak ditemukan (ID: $kosId)'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Icon(Icons.home_work, size: 72),
              const SizedBox(height: 12),
              Text(
                kos.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.place),
                title: const Text('Alamat'),
                subtitle: Text(kos.address ?? '-'),
              ),
              ListTile(
                leading: const Icon(Icons.payments),
                title: const Text('Harga'),
                subtitle: Text(kos.priceText),
              ),
              ListTile(
                leading: const Icon(Icons.key),
                title: const Text('ID kos'),
                subtitle: SelectableText(kos.id),
              ),
            ],
          );
        },
      ),
    );
  }
}
