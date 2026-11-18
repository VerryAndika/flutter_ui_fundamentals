// P9 Praktik 5: model satu baris tabel public.kos (memiliki owner_id).
class Kos {
  const Kos({
    required this.id,
    required this.ownerId,
    required this.name,
    this.address,
    this.price,
    this.createdAt,
  });

  final String id;
  final String ownerId;
  final String name;
  final String? address;
  final int? price;
  final DateTime? createdAt;

  factory Kos.fromMap(Map<String, dynamic> m) => Kos(
    id: m['id'] as String,
    ownerId: m['owner_id'] as String,
    name: (m['name'] ?? '-') as String,
    address: m['address'] as String?,
    price: (m['price'] as num?)?.toInt(),
    createdAt: DateTime.tryParse(m['created_at'] as String? ?? ''),
  );

  String get priceText {
    final p = price;
    if (p == null) return '-';
    final s = p.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );
    return 'Rp $s / bulan';
  }
}
