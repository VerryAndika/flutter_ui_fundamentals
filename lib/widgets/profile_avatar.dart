import 'package:flutter/material.dart';

// Tahap 5: foto profil dari asset. Jika file tidak ada,
// tampilkan Icon(Icons.person) sebagai pengganti.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, this.radius = 40});

  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: ClipOval(
        child: Image.asset(
          'assets/images/profile.jpg',
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.person, size: radius),
        ),
      ),
    );
  }
}
