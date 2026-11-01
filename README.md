# Flutter UI Fundamentals – Learning Dashboard & Course Explorer

Praktikum Pertemuan 4 dan 5 Pemrograman Mobile.

**2415051065 - I Kadek Very Andika** (5 IKI)

Aplikasi Flutter yang menampilkan identitas mahasiswa, ringkasan materi, dan
daftar materi dari file JSON statik (`assets/data/student_data.json`).

## Menjalankan

```bash
flutter pub get
flutter run
```

Halaman utama adalah **Course Explorer** (Pertemuan 5). Learning Dashboard (Pertemuan 4) ada di route `/p4`. Menu drawer membuka halaman
latihan, daftar topik, dan debugging. Hasil tiap tahap juga dapat dibuka
langsung lewat route, misalnya `/#/tahap5` saat dijalankan di web.

| Route | Tahap |
|---|---|
| `/tahap1` … `/tahap9` | Widget dasar, layout, styling, reusable widget, input & state |
| `/tahap10`, `/tahap11` | List dari `List<Map<String, dynamic>>` |
| `/tahap12`, `/tahap13` | JSON statik, `late` + `FutureBuilder` |
| `/p4` | P4 Tahap 14 – Learning Dashboard |
| `/` | P5 – Course Explorer (NavigationBar/NavigationRail) |
| `/p5/tahap1` … `/p5/tahap16` | Pertemuan 5 per tahap, lihat [JAWABAN_P5.md](JAWABAN_P5.md) |
| `/tahap15-overflow` | Tahap 15 Kasus A sebelum diperbaiki (overflow, terlihat di mode debug) |
| `/tahap15` | Tahap 15 Kasus A sesudah diperbaiki dengan `Expanded` |

Jawaban worksheet: [JAWABAN.md](JAWABAN.md) (P4) dan [JAWABAN_P5.md](JAWABAN_P5.md) (P5).
Screenshot bukti: [docs/screenshots](docs/screenshots) dan [docs/p5](docs/p5).
