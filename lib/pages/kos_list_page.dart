import 'package:flutter/material.dart';

import '../models/kos.dart';
import '../services/kos_service.dart';
import 'kos_detail_page.dart';
import 'kos_form_page.dart';

// P9 Praktik 5: daftar kos. Tombol edit/hapus hanya pada kos milik sendiri
// (UI); database tetap menolak operasi pada kos orang lain (RLS).
class KosListPage extends StatefulWidget {
  const KosListPage({super.key, this.onlyMine = false, this.isAdmin = false});

  final bool onlyMine;
  final bool isAdmin;

  @override
  State<KosListPage> createState() => _KosListPageState();
}

class _KosListPageState extends State<KosListPage> {
  final _service = KosService();
  late Future<List<Kos>> _future = _service.fetchAll();
  final _search = TextEditingController();

  void _reload() => setState(() => _future = _service.fetchAll());

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _delete(Kos kos) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Hapus kos?'),
        content: Text('"${kos.name}" akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final deleted = await _service.delete(kos.id);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            deleted
                ? '"${kos.name}" dihapus'
                : 'DITOLAK oleh RLS (bukan milik Anda)',
          ),
        ),
      );
      _reload();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(kosErrorMessage(e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final myId = _service.currentUserId;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.onlyMine ? 'My Kos' : 'Daftar Kos'),
        actions: [
          IconButton(
            tooltip: 'Muat ulang',
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          if (!widget.onlyMine)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: TextField(
                controller: _search,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Cari nama / alamat kos (fitur pencari kos)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          Expanded(
            child: FutureBuilder<List<Kos>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(child: Text(kosErrorMessage(snap.error!)));
                }
                final q = _search.text.trim().toLowerCase();
                final items = snap.data!
                    .where((k) => !widget.onlyMine || k.ownerId == myId)
                    .where(
                      (k) =>
                          q.isEmpty ||
                          k.name.toLowerCase().contains(q) ||
                          (k.address ?? '').toLowerCase().contains(q),
                    )
                    .toList();
                if (items.isEmpty) {
                  return const Center(child: Text('Belum ada data kos.'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final kos = items[i];
                    final isMine = kos.ownerId == myId;
                    final canManage = isMine || widget.isAdmin;
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(isMine ? Icons.home_work : Icons.home),
                        ),
                        title: Text(kos.name),
                        subtitle: Text(
                          '${kos.address ?? '-'}\n${kos.priceText}'
                          '${isMine ? '  •  milik saya' : ''}',
                        ),
                        isThreeLine: true,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => KosDetailPage(kosId: kos.id),
                          ),
                        ),
                        trailing: canManage
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Edit',
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      final changed =
                                          await Navigator.of(context)
                                              .push<bool>(
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      KosFormPage(kos: kos),
                                                ),
                                              );
                                      if (changed == true) _reload();
                                    },
                                  ),
                                  IconButton(
                                    tooltip: 'Hapus',
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _delete(kos),
                                  ),
                                ],
                              )
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
