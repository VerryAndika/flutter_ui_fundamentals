import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/identity_header.dart';
import '../../providers/course_provider.dart';

// Tahap 6: membuktikan CourseProvider tersedia di widget tree.
class ProviderSetupPage extends StatelessWidget {
  const ProviderSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('P6 Tahap 6 - Provider Setup')),
      body: ListView(
        children: [
          const IdentityHeader(subtitle: 'ChangeNotifierProvider'),
          ListTile(
            leading: const Icon(Icons.check_circle, color: Colors.green),
            title: Text('Provider ditemukan: ${provider.runtimeType}'),
            subtitle: Text('Favorite saat ini: ${provider.favoriteCount}'),
          ),
          const ListTile(
            leading: Icon(Icons.account_tree_outlined),
            title: Text('ChangeNotifierProvider → MyApp → MaterialApp → ...'),
            subtitle: Text(
              'Semua halaman berada di bawah provider sehingga bisa '
              'memanggil context.watch/read<CourseProvider>().',
            ),
          ),
        ],
      ),
    );
  }
}
