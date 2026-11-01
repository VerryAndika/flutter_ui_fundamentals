import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/identity_header.dart';

// Tahap 15: Debugging state management.
// Kasus A (hapus notifyListeners) dan C (error CourseService) dilakukan
// dengan mengubah kode sementara saat aplikasi berjalan, lalu dikembalikan.
class StateDebuggingPage extends StatelessWidget {
  const StateDebuggingPage({super.key});

  Widget _case(
    BuildContext context,
    String title,
    String before,
    String after,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, before),
                  child: const Text('Sebelum'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pushNamed(context, after),
                  child: const Text('Sesudah'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('P6 Tahap 15 - Debugging State')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 16),
        children: [
          const IdentityHeader(subtitle: 'Debugging Provider'),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _case(
                  context,
                  'B - Provider dari context di atas provider',
                  '/p6/kasus-b-error',
                  '/p6/kasus-b',
                ),
                _case(
                  context,
                  'D - setState setelah async (mounted)',
                  '/p6/kasus-d-error',
                  '/p6/kasus-d',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Kasus B ----------
class DemoCounter extends ChangeNotifier {
  int value = 0;

  void increment() {
    value++;
    notifyListeners();
  }
}

class ProviderScopePage extends StatelessWidget {
  const ProviderScopePage({super.key, required this.fixed});

  final bool fixed;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DemoCounter(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Kasus B - ${fixed ? 'Sesudah' : 'Sebelum'}'),
        ),
        body: Column(
          children: [
            const IdentityHeader(subtitle: 'ChangeNotifierProvider lokal'),
            const SizedBox(height: 24),
            if (fixed)
              // Builder memberi context baru yang berada DI BAWAH provider.
              Builder(
                builder: (inner) => Text(
                  'Nilai: ${inner.watch<DemoCounter>().value}',
                  style: const TextStyle(fontSize: 24),
                ),
              )
            else
              // context milik build() ini berada DI ATAS provider.
              Text(
                'Nilai: ${context.watch<DemoCounter>().value}',
                style: const TextStyle(fontSize: 24),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------- Kasus D ----------
class AsyncLoadPage extends StatefulWidget {
  const AsyncLoadPage({super.key, required this.fixed});

  final bool fixed;

  @override
  State<AsyncLoadPage> createState() => _AsyncLoadPageState();
}

class _AsyncLoadPageState extends State<AsyncLoadPage> {
  String status = 'Belum dimuat';

  Future<void> _load() async {
    setState(() => status = 'Memuat 2 detik...');
    await Future<void>.delayed(const Duration(seconds: 2));
    // Sesudah: halaman bisa sudah ditutup ketika Future selesai.
    if (widget.fixed && !mounted) return;
    setState(() => status = 'Selesai dimuat');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kasus D - ${widget.fixed ? 'Sesudah' : 'Sebelum'}'),
      ),
      body: Column(
        children: [
          const IdentityHeader(subtitle: 'Tekan muat lalu kembali'),
          const SizedBox(height: 24),
          Text(status, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 12),
          FilledButton(onPressed: _load, child: const Text('Muat data')),
        ],
      ),
    );
  }
}
