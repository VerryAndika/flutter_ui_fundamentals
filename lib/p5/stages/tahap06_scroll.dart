import 'package:flutter/material.dart';

import '../widgets/identity_header.dart';

// Isi halaman profil/form yang lebih tinggi dari layar.
List<Widget> _profileContent() => [
  const IdentityHeader(subtitle: 'Profil'),
  const SizedBox(height: 16),
  for (final label in ['Program Studi', 'Angkatan', 'Email', 'Hobi'])
    Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    ),
  for (var i = 1; i <= 7; i++)
    Card(
      child: ListTile(
        leading: const Icon(Icons.star_outline),
        title: Text('Pencapaian $i'),
        subtitle: const Text('Deskripsi singkat pencapaian.'),
      ),
    ),
  const SizedBox(height: 12),
  const TextField(
    decoration: InputDecoration(
      labelText: 'Catatan (paling bawah)',
      border: OutlineInputBorder(),
    ),
  ),
];

// Tahap 6 (sebelum): Column biasa -> bottom overflow.
class ScrollBeforePage extends StatelessWidget {
  const ScrollBeforePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('P5 Tahap 6 - Tanpa Scroll')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: _profileContent()),
      ),
    );
  }
}

// Tahap 6 (sesudah): SingleChildScrollView, tetap bisa di-scroll
// ketika keyboard muncul.
class ScrollAfterPage extends StatelessWidget {
  const ScrollAfterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('P5 Tahap 6 - SingleChildScrollView')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: _profileContent()),
      ),
    );
  }
}
