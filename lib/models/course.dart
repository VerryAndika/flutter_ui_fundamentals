// P6 Tahap 8: model Course menggantikan Map<String, dynamic> di UI.
// P7 Tahap 3: tambah id (nullable, dari backend) dan toJson() untuk body
// request. status default 'planned' jika JSON tidak mengirimnya.
class Course {
  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;
  // Hanya ada di JSON lokal Pertemuan 4-6, tidak dikirim ke backend.
  final int progress;

  const Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    this.status = 'planned',
    this.progress = 0,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      code: json['code'] as String,
      title: json['title'] as String,
      credits: json['credits'] as int,
      status: (json['status'] as String?) ?? 'planned',
      progress: json['progress'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'title': title,
    'credits': credits,
    'status': status,
  };

  String get statusLabel => switch (status) {
    'done' => 'Selesai',
    'active' => 'Berjalan',
    _ => 'Rencana',
  };
}
