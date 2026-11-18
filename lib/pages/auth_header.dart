import 'package:flutter/material.dart';

import '../identity.dart';

// Header halaman Login/Register: nama aplikasi + identitas mahasiswa.
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.subtitle});

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        const SizedBox(height: 8),
        CircleAvatar(
          radius: 34,
          backgroundColor: scheme.primaryContainer,
          child: Icon(Icons.home_work_rounded, size: 36, color: scheme.primary),
        ),
        const SizedBox(height: 12),
        Text(
          'KosFinder',
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(subtitle, textAlign: TextAlign.center),
        const SizedBox(height: 4),
        Text(
          'P9 • $studentId - $studentName',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
