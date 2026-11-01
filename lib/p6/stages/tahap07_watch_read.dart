import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/identity_header.dart';
import '../../providers/course_provider.dart';

const List<(String, String)> _courses = [
  ('MOB04', 'Navigation & Routing'),
  ('MOB05', 'State Management'),
  ('MOB06', 'REST API & HTTP'),
];

// Hitungan build per bagian, untuk mengamati bagian yang di-rebuild.
final Map<String, int> _builds = {};
int _count(String key) => _builds[key] = (_builds[key] ?? 0) + 1;

// Tahap 7: context.watch, context.read, dan Consumer.
class WatchReadPage extends StatelessWidget {
  const WatchReadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('P6 Tahap 7 - watch / read')),
      body: ListView(
        children: const [
          IdentityHeader(subtitle: 'watch, read, Consumer'),
          FavoriteCountTile(),
          StaticInfoTile(),
          CourseButtons(),
        ],
      ),
    );
  }
}

// watch(): listen, sehingga ikut rebuild ketika favorite berubah.
class FavoriteCountTile extends StatelessWidget {
  const FavoriteCountTile({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final n = _count('watch');
    return ListTile(
      leading: const Icon(Icons.favorite, color: Colors.pink),
      title: Text('watch(): ${provider.favoriteCount} favorite'),
      subtitle: Text('build ke-$n'),
    );
  }
}

// Tidak listen sama sekali: tidak ikut rebuild.
class StaticInfoTile extends StatelessWidget {
  const StaticInfoTile({super.key});

  @override
  Widget build(BuildContext context) {
    final n = _count('static');
    return ListTile(
      leading: const Icon(Icons.info_outline),
      title: const Text('Widget tanpa listen'),
      subtitle: Text('build ke-$n'),
    );
  }
}

// read() untuk aksi, Consumer hanya membungkus ikon kecil.
class CourseButtons extends StatelessWidget {
  const CourseButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final n = _count('buttons');
    return Column(
      children: [
        ListTile(
          dense: true,
          title: const Text('Daftar course (read untuk aksi)'),
          subtitle: Text('build ke-$n'),
        ),
        for (final (code, title) in _courses)
          ListTile(
            title: Text(title),
            subtitle: Text(code),
            trailing: Consumer<CourseProvider>(
              builder: (context, provider, child) {
                final c = _count('consumer-$code');
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Consumer #$c'),
                    IconButton(
                      icon: Icon(
                        provider.isFavorite(code)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: provider.isFavorite(code) ? Colors.pink : null,
                      ),
                      onPressed: () {
                        context.read<CourseProvider>().toggleFavorite(code);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}
