import 'package:flutter/material.dart';

import '../../identity.dart';
import '../widgets/identity_header.dart';

// Tahap 16: Debugging Challenge. Setiap kasus punya versi "sebelum"
// (error sengaja dibiarkan) dan "sesudah" (sudah diperbaiki).
class DebuggingHubPage extends StatelessWidget {
  const DebuggingHubPage({super.key});

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
      appBar: AppBar(title: const Text('P5 Tahap 16 - Debugging')),
      body: ListView(
        children: [
          const IdentityHeader(subtitle: 'Debugging challenge'),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _case(
                  context,
                  'A - RenderFlex overflow',
                  '/p5/kasus-a-error',
                  '/p5/kasus-a',
                ),
                _case(
                  context,
                  'B - Unbounded ListView',
                  '/p5/kasus-b-error',
                  '/p5/kasus-b',
                ),
                _case(
                  context,
                  'C - Keyboard overflow',
                  '/p5/kasus-c-error',
                  '/p5/kasus-c',
                ),
                _case(
                  context,
                  'D - Navigasi ganda',
                  '/p5/kasus-d-error',
                  '/p5/kasus-d',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Kasus A ----------
class OverflowRowPage extends StatelessWidget {
  const OverflowRowPage({super.key, required this.fixed});

  final bool fixed;

  @override
  Widget build(BuildContext context) {
    const text = Text(
      '$studentId - $studentName - teks sangat panjang untuk menguji Row',
    );
    return Scaffold(
      appBar: AppBar(title: Text('Kasus A - ${fixed ? 'Sesudah' : 'Sebelum'}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.info),
            const SizedBox(width: 8),
            // Expanded memberi Text lebar yang terbatas sehingga bisa wrap.
            if (fixed) const Expanded(child: text) else text,
          ],
        ),
      ),
    );
  }
}

// ---------- Kasus B ----------
class UnboundedListPage extends StatelessWidget {
  const UnboundedListPage({super.key, required this.fixed});

  final bool fixed;

  @override
  Widget build(BuildContext context) {
    final list = ListView.builder(
      itemCount: 20,
      itemBuilder: (_, i) => ListTile(title: Text('Item ${i + 1}')),
    );
    return Scaffold(
      appBar: AppBar(title: Text('Kasus B - ${fixed ? 'Sesudah' : 'Sebelum'}')),
      body: Column(
        children: [
          const IdentityHeader(subtitle: 'ListView di dalam Column'),
          // Tanpa Expanded, ListView mendapat tinggi tak terbatas.
          if (fixed) Expanded(child: list) else list,
        ],
      ),
    );
  }
}

// ---------- Kasus C ----------
class KeyboardFormPage extends StatelessWidget {
  const KeyboardFormPage({super.key, required this.fixed});

  final bool fixed;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const IdentityHeader(subtitle: 'Form di bagian bawah'),
        const SizedBox(height: 360),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Komentar',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FilledButton(onPressed: () {}, child: const Text('Kirim')),
        ),
        const SizedBox(height: 16),
      ],
    );
    return Scaffold(
      appBar: AppBar(title: Text('Kasus C - ${fixed ? 'Sesudah' : 'Sebelum'}')),
      // Sesudah: konten bisa di-scroll ketika tinggi berkurang oleh keyboard.
      body: fixed ? SingleChildScrollView(child: content) : content,
    );
  }
}

// ---------- Kasus D ----------
int _openedDetail = 0;

class DoubleNavigationPage extends StatefulWidget {
  const DoubleNavigationPage({super.key, required this.fixed});

  final bool fixed;

  @override
  State<DoubleNavigationPage> createState() => _DoubleNavigationPageState();
}

class _DoubleNavigationPageState extends State<DoubleNavigationPage> {
  bool navigating = false;

  Future<void> _open() async {
    // Sesudah: guard agar tap berulang tidak mem-push route berkali-kali.
    if (widget.fixed && navigating) return;
    navigating = true;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const _OpenedPage()),
    );
    navigating = false;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kasus D - ${widget.fixed ? 'Sesudah' : 'Sebelum'}'),
      ),
      body: Column(
        children: [
          const IdentityHeader(subtitle: 'Tekan tombol berulang kali'),
          const SizedBox(height: 24),
          FilledButton.icon(
            icon: const Icon(Icons.open_in_new),
            label: const Text('Buka Detail'),
            onPressed: _open,
          ),
          const SizedBox(height: 12),
          Text('Total halaman detail ter-push: $_openedDetail'),
          TextButton(
            onPressed: () => setState(() => _openedDetail = 0),
            child: const Text('Reset hitungan'),
          ),
        ],
      ),
    );
  }
}

class _OpenedPage extends StatefulWidget {
  const _OpenedPage();

  @override
  State<_OpenedPage> createState() => _OpenedPageState();
}

class _OpenedPageState extends State<_OpenedPage> {
  late final int number;

  @override
  void initState() {
    super.initState();
    number = ++_openedDetail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail #$number')),
      body: Center(
        child: Text(
          'Halaman detail ke-$number\n(total ter-push: $_openedDetail)',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
