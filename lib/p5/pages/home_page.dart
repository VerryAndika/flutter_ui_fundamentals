import 'package:flutter/material.dart';

import '../favorites.dart';
import '../stages/tahap03_layoutbuilder.dart';
import '../widgets/identity_header.dart';

// Daftar hasil per tahap, dapat dibuka dari Home.
const List<(String, String)> stageLinks = [
  ('/p5/tahap1', 'Tahap 1 - Hard-coded vs flexible'),
  ('/p5/tahap2', 'Tahap 2 - MediaQuery'),
  ('/p5/tahap3', 'Tahap 3 - LayoutBuilder & breakpoint'),
  ('/p5/tahap4', 'Tahap 4 - Expanded, Flexible, Wrap'),
  ('/p5/tahap5', 'Tahap 5 - GridView responsif'),
  ('/p5/tahap6', 'Tahap 6 - SingleChildScrollView'),
  ('/p5/tahap7', 'Tahap 7 - Navigator push/pop'),
  ('/p5/tahap8', 'Tahap 8-9 - Passing & returning data'),
  ('/p5/tahap12', 'Tahap 12 - Interaction'),
  ('/p5/tahap13', 'Tahap 13-14 - Form & feedback'),
  ('/p5/tahap16', 'Tahap 16 - Debugging challenge'),
];

// Destinasi Home pada Course Explorer.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _stat(IconData icon, String value, String label) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ListView(
      children: [
        const IdentityHeader(subtitle: 'Home'),
        Padding(
          padding: const EdgeInsets.all(12),
          child: ValueListenableBuilder<Set<String>>(
            valueListenable: favoriteCodes,
            builder: (context, favorites, _) => Row(
              children: [
                _stat(Icons.school, '6', 'Course'),
                _stat(Icons.favorite, '${favorites.length}', 'Favorite'),
                _stat(
                  Icons.aspect_ratio,
                  windowSizeLabel(width),
                  '${width.toStringAsFixed(0)} dp',
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
            'Latihan per tahap',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        for (final (route, label) in stageLinks)
          ListTile(
            dense: true,
            leading: const Icon(Icons.play_lesson_outlined),
            title: Text(label),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, route),
          ),
      ],
    );
  }
}
