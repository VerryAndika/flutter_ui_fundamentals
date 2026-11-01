import 'package:flutter/material.dart';

import '../../widgets/identity_header.dart';

// Tahap 3: state "favorite" dimiliki parent (single source of truth).
// Child hanya menerima nilai lewat constructor dan mengirim aksi lewat
// callback, sehingga dua widget selalu menampilkan nilai yang sama.
class LiftingStatePage extends StatefulWidget {
  const LiftingStatePage({super.key});

  @override
  State<LiftingStatePage> createState() => _LiftingStatePageState();
}

class _LiftingStatePageState extends State<LiftingStatePage> {
  bool favorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('P6 Tahap 3 - Lifting State Up')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 16),
        children: [
          const IdentityHeader(subtitle: 'single source of truth'),
          SimpleCourseCard(
            title: 'State Management',
            isFavorite: favorite,
            onFavoriteChanged: () {
              setState(() {
                favorite = !favorite;
              });
            },
          ),
          FavoriteBadge(isFavorite: favorite),
        ],
      ),
    );
  }
}

class SimpleCourseCard extends StatelessWidget {
  const SimpleCourseCard({
    super.key,
    required this.title,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  final String title;
  final bool isFavorite;
  final VoidCallback onFavoriteChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: ListTile(
        leading: const Icon(Icons.menu_book),
        title: Text(title),
        subtitle: const Text('Widget 1: CourseCard'),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.pink : null,
          ),
          onPressed: onFavoriteChanged,
        ),
      ),
    );
  }
}

class FavoriteBadge extends StatelessWidget {
  const FavoriteBadge({super.key, required this.isFavorite});

  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: isFavorite ? Colors.pink.shade50 : null,
      child: ListTile(
        leading: Icon(isFavorite ? Icons.star : Icons.star_border),
        title: Text(isFavorite ? 'Favorite: YA' : 'Favorite: TIDAK'),
        subtitle: const Text('Widget 2: badge membaca nilai yang sama'),
      ),
    );
  }
}
