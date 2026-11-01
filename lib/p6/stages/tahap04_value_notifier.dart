import 'package:flutter/material.dart';

import '../../p5/widgets/identity_header.dart';

// Tahap 4: ValueNotifier + ValueListenableBuilder.
// Penghitung build menunjukkan bahwa hanya builder yang dibangun ulang,
// sedangkan setState() membangun ulang seluruh halaman.
class ValueNotifierPage extends StatefulWidget {
  const ValueNotifierPage({super.key});

  @override
  State<ValueNotifierPage> createState() => _ValueNotifierPageState();
}

class _ValueNotifierPageState extends State<ValueNotifierPage> {
  final ValueNotifier<int> favoriteCount = ValueNotifier(0);
  int setStateCount = 0;
  int pageBuilds = 0;
  int builderBuilds = 0;

  @override
  void dispose() {
    favoriteCount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pageBuilds++;
    return Scaffold(
      appBar: AppBar(title: const Text('P6 Tahap 4 - ValueNotifier')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 16),
        children: [
          const IdentityHeader(subtitle: 'ValueListenableBuilder'),
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: favoriteCount,
                    builder: (context, value, child) {
                      builderBuilds++;
                      return Text(
                        'Jumlah favorite: $value',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    icon: const Icon(Icons.favorite),
                    label: const Text('Tambah (ValueNotifier)'),
                    onPressed: () => favoriteCount.value++,
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Jumlah (setState): $setStateCount',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => setState(() => setStateCount++),
                    child: const Text('Tambah (setState)'),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Build halaman: $pageBuilds kali\n'
              'Build ValueListenableBuilder: $builderBuilds kali',
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
}
