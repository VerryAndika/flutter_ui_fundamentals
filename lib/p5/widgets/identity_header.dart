import 'package:flutter/material.dart';

import '../../identity.dart';

// Header identitas mahasiswa yang dipakai di banyak halaman P5.
class IdentityHeader extends StatelessWidget {
  const IdentityHeader({super.key, this.subtitle});

  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: scheme.primaryContainer,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
            child: const Icon(Icons.person),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  studentName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(subtitle == null ? studentId : '$studentId • $subtitle'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
