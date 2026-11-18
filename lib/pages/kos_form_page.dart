import 'package:flutter/material.dart';

import '../models/kos.dart';
import '../services/kos_service.dart';

// P9 Praktik 5: form tambah / edit kos (owner).
class KosFormPage extends StatefulWidget {
  const KosFormPage({super.key, this.kos});

  final Kos? kos; // null = tambah

  @override
  State<KosFormPage> createState() => _KosFormPageState();
}

class _KosFormPageState extends State<KosFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final _nameC = TextEditingController(text: widget.kos?.name);
  late final _addressC = TextEditingController(text: widget.kos?.address);
  late final _priceC = TextEditingController(
    text: widget.kos?.price?.toString(),
  );
  bool _saving = false;

  @override
  void dispose() {
    _nameC.dispose();
    _addressC.dispose();
    _priceC.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    setState(() => _saving = true);
    try {
      final service = KosService();
      final price = int.parse(_priceC.text.trim());
      if (widget.kos == null) {
        await service.add(
          name: _nameC.text.trim(),
          address: _addressC.text.trim(),
          price: price,
        );
        messenger.showSnackBar(
          const SnackBar(content: Text('Kos ditambahkan')),
        );
      } else {
        final ok = await service.update(widget.kos!.id, {
          'name': _nameC.text.trim(),
          'address': _addressC.text.trim(),
          'price': price,
        });
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              ok ? 'Kos diperbarui' : 'DITOLAK: kos ini bukan milik Anda (RLS)',
            ),
          ),
        );
      }
      navigator.pop(true);
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(kosErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kos == null ? 'Tambah Kos' : 'Edit Kos'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _nameC,
                  decoration: const InputDecoration(
                    labelText: 'Nama kos',
                    prefixIcon: Icon(Icons.home_work_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Nama wajib diisi'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressC,
                  decoration: const InputDecoration(
                    labelText: 'Alamat',
                    prefixIcon: Icon(Icons.place_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Alamat wajib diisi'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _priceC,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Harga per bulan (Rp)',
                    prefixIcon: Icon(Icons.payments_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    final n = int.tryParse(v?.trim() ?? '');
                    if (n == null) return 'Harga harus angka';
                    if (n <= 0) return 'Harga harus lebih dari 0';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
