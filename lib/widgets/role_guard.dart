import 'package:flutter/material.dart';

// P9 Praktik 4: tampilkan child hanya jika role termasuk yang diizinkan.
// Catatan: ini hanya mengamankan UI. Keamanan data tetap ditegakkan oleh
// Row Level Security di database (Praktik 5).
class RoleGuard extends StatelessWidget {
  const RoleGuard({
    super.key,
    required this.role,
    required this.allowed,
    required this.child,
  });

  final String role;
  final List<String> allowed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return allowed.contains(role) ? child : const SizedBox.shrink();
  }
}
