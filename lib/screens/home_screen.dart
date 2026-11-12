import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/identity_header.dart';

// Ringkasan state aplikasi, dibaca dengan context.watch.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
    final provider = context.watch<CourseProvider>();
    final totalCredits = provider.courses.fold<int>(
      0,
      (sum, c) => sum + c.credits,
    );
    return ListView(
      children: [
        const IdentityHeader(subtitle: 'Home'),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _stat(Icons.school, '${provider.courses.length}', 'Course'),
              _stat(Icons.favorite, '${provider.favoriteCount}', 'Favorite'),
              _stat(Icons.functions, '$totalCredits', 'Total SKS'),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.sync),
          title: const Text('Status data'),
          trailing: Text(provider.status.name),
        ),
        const ListTile(
          leading: Icon(Icons.account_tree_outlined),
          title: Text('Alur data'),
          subtitle: Text(
            'Screen → CourseProvider → CourseRepository → '
            'CourseSupabaseService → Supabase (tabel courses)',
          ),
        ),
      ],
    );
  }
}
