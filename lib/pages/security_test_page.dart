import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../identity.dart';
import '../models/kos.dart';
import '../services/kos_service.dart';

// P9 Praktik 6: Security Testing dari aplikasi.
// Login sebagai User B, lalu coba ubah/hapus kos milik User A dan INSERT
// atas nama user lain. Semua operasi itu harus DITOLAK oleh RLS.
class SecurityTestPage extends StatefulWidget {
  const SecurityTestPage({super.key});

  @override
  State<SecurityTestPage> createState() => _SecurityTestPageState();
}

class _Result {
  _Result(this.test, this.expected, this.actual, this.pass);
  final String test;
  final String expected;
  final String actual;
  final bool pass;
}

class _SecurityTestPageState extends State<SecurityTestPage> {
  final _service = KosService();
  final _results = <_Result>[];
  bool _running = false;
  Kos? _target;

  Future<void> _run() async {
    setState(() {
      _running = true;
      _results.clear();
    });
    final me = _service.currentUserId;
    try {
      // 1. Membaca data yang diperbolehkan.
      final all = await _service.fetchAll();
      _results.add(
        _Result(
          'Membaca daftar kos',
          'Allowed',
          '${all.length} baris terbaca',
          true,
        ),
      );

      final mine = all.where((k) => k.ownerId == me).toList();
      final others = all.where((k) => k.ownerId != me).toList();

      // 2. Mengedit data milik sendiri (jika punya).
      if (mine.isNotEmpty) {
        final k = mine.first;
        final ok = await _service.update(k.id, {'name': k.name});
        _results.add(
          _Result(
            'Mengedit kos milik sendiri ("${k.name}")',
            'Allowed',
            ok ? 'Berhasil (1 baris)' : 'Ditolak',
            ok,
          ),
        );
      }

      if (others.isEmpty) {
        _results.add(
          _Result(
            'Kos milik user lain',
            '-',
            'Tidak ada kos milik user lain untuk diuji',
            false,
          ),
        );
      } else {
        final victim = others.first;
        _target = victim;
        // 3. UPDATE kos milik user lain -> harus DENIED.
        final updated = await _service.update(victim.id, {
          'name': 'DIUBAH USER LAIN',
        });
        _results.add(
          _Result(
            'Mengedit kos milik user lain ("${victim.name}")',
            'Denied',
            updated
                ? 'BERHASIL diubah (bahaya!)'
                : 'UPDATE 0 baris (ditolak RLS)',
            !updated,
          ),
        );
        // 4. DELETE kos milik user lain -> harus DENIED.
        final deleted = await _service.delete(victim.id);
        _results.add(
          _Result(
            'Menghapus kos milik user lain',
            'Denied',
            deleted
                ? 'BERHASIL dihapus (bahaya!)'
                : 'DELETE 0 baris (ditolak RLS)',
            !deleted,
          ),
        );
        // 5. INSERT atas nama user lain -> harus ERROR 42501.
        try {
          await Supabase.instance.client.from('kos').insert({
            'owner_id': victim.ownerId,
            'name': 'Kos palsu',
          });
          _results.add(
            _Result(
              'INSERT kos atas nama user lain',
              'Denied',
              'BERHASIL (bahaya!)',
              false,
            ),
          );
        } on PostgrestException catch (e) {
          _results.add(
            _Result(
              'INSERT kos atas nama user lain',
              'Denied',
              'Error ${e.code}: ${e.message}',
              true,
            ),
          );
        }
      }
    } catch (e) {
      _results.add(_Result('Pengujian', '-', kosErrorMessage(e), false));
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = Supabase.instance.client.auth.currentUser?.email ?? '-';
    return Scaffold(
      appBar: AppBar(title: const Text('Security Testing (RLS)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Login sebagai: $email'),
          const Text('P9 • $studentId - $studentName'),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _running ? null : _run,
            icon: _running
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.security),
            label: const Text('Jalankan pengujian'),
          ),
          if (_target != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Target: kos "${_target!.name}" (id ${_target!.id.substring(0, 8)}…) '
                'milik user lain',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          const SizedBox(height: 12),
          for (final r in _results)
            Card(
              color: r.pass
                  ? Colors.green.withValues(alpha: 0.12)
                  : Colors.red.withValues(alpha: 0.12),
              child: ListTile(
                leading: Icon(
                  r.pass ? Icons.check_circle : Icons.cancel,
                  color: r.pass ? Colors.green : Colors.red,
                ),
                title: Text(r.test),
                subtitle: Text('Expected: ${r.expected}\nActual: ${r.actual}'),
                isThreeLine: true,
                trailing: Text(
                  r.pass ? 'PASS' : 'FAIL',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: r.pass ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
