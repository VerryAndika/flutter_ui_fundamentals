import 'package:flutter/material.dart';

import '../../p5/widgets/identity_header.dart';

const List<(String, String)> _courses = [
  ('MOB04', 'Navigation & Routing'),
  ('MOB05', 'State Management'),
  ('MOB06', 'REST API & HTTP'),
];

// Tahap 2: favorites disimpan di parent, lalu diteruskan lewat
// constructor dan callback melewati beberapa level widget.
class PropDrillingPage extends StatefulWidget {
  const PropDrillingPage({super.key});

  @override
  State<PropDrillingPage> createState() => _PropDrillingPageState();
}

class _PropDrillingPageState extends State<PropDrillingPage> {
  final Set<String> favorites = {};

  void toggle(String code) => setState(() {
    favorites.contains(code) ? favorites.remove(code) : favorites.add(code);
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('P6 Tahap 2 - Prop Drilling')),
      body: ListView(
        children: [
          const IdentityHeader(subtitle: 'favorites di parent'),
          // Child 1: hanya menampilkan jumlah.
          FavoriteSummary(favorites: favorites),
          // Child 2: favorites + callback harus diteruskan dua level.
          CourseSection(favorites: favorites, onToggle: toggle),
        ],
      ),
    );
  }
}

class FavoriteSummary extends StatelessWidget {
  const FavoriteSummary({super.key, required this.favorites});

  final Set<String> favorites;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: ListTile(
        leading: const Icon(Icons.favorite, color: Colors.pink),
        title: Text('${favorites.length} favorite'),
        subtitle: Text(favorites.isEmpty ? '-' : favorites.join(', ')),
      ),
    );
  }
}

// Level tengah: tidak memakai favorites, tetapi wajib meneruskannya.
class CourseSection extends StatelessWidget {
  const CourseSection({
    super.key,
    required this.favorites,
    required this.onToggle,
  });

  final Set<String> favorites;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final (code, title) in _courses)
          CourseRow(
            code: code,
            title: title,
            favorite: favorites.contains(code),
            onToggle: () => onToggle(code),
          ),
      ],
    );
  }
}

class CourseRow extends StatelessWidget {
  const CourseRow({
    super.key,
    required this.code,
    required this.title,
    required this.favorite,
    required this.onToggle,
  });

  final String code;
  final String title;
  final bool favorite;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(code),
      trailing: IconButton(
        icon: Icon(
          favorite ? Icons.favorite : Icons.favorite_border,
          color: favorite ? Colors.pink : null,
        ),
        onPressed: onToggle,
      ),
    );
  }
}
