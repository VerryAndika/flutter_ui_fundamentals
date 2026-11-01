// P6 Tahap 8: model Course menggantikan Map<String, dynamic> di UI.
class Course {
  final String code;
  final String title;
  final int credits;
  final String status;
  final int progress;

  const Course({
    required this.code,
    required this.title,
    required this.credits,
    required this.status,
    this.progress = 0,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      code: json['code'] as String,
      title: json['title'] as String,
      credits: json['credits'] as int,
      status: json['status'] as String,
      progress: json['progress'] as int? ?? 0,
    );
  }

  String get statusLabel => switch (status) {
    'done' => 'Selesai',
    'active' => 'Berjalan',
    _ => 'Rencana',
  };
}
