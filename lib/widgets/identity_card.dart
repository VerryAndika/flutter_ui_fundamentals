import 'package:flutter/material.dart';

import 'profile_avatar.dart';

// Tahap 7 & 14: kartu identitas (Card + Padding + Row/Column).
class IdentityCard extends StatelessWidget {
  const IdentityCard({
    super.key,
    required this.name,
    required this.nim,
    this.motto,
  });

  final String name;
  final String nim;
  final String? motto;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const ProfileAvatar(radius: 36),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('NIM: $nim'),
                  if (motto != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      '"$motto"',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
