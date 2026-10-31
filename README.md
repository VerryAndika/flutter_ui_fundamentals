# Flutter UI Fundamentals – Learning Dashboard

Praktikum Pertemuan 4 Pemrograman Mobile.

**2415051065 - I Kadek Very Andika** (5 IKI)

Aplikasi Flutter yang menampilkan identitas mahasiswa, ringkasan materi, dan
daftar materi dari file JSON statik (`assets/data/student_data.json`).

## Menjalankan

```bash
flutter pub get
flutter run
```

Halaman utama adalah **Learning Dashboard**. Menu drawer membuka halaman
latihan, daftar topik, dan debugging. Hasil tiap tahap juga dapat dibuka
langsung lewat route, misalnya `/#/tahap5` saat dijalankan di web.

| Route | Tahap |
|---|---|
| `/tahap1` … `/tahap9` | Widget dasar, layout, styling, reusable widget, input & state |
| `/tahap10`, `/tahap11` | List dari `List<Map<String, dynamic>>` |
| `/tahap12`, `/tahap13` | JSON statik, `late` + `FutureBuilder` |
| `/` | Tahap 14 – Learning Dashboard |
| `/tahap15`, `/tahap15-error` | Debugging overflow & error state |

Jawaban pertanyaan worksheet ada di [JAWABAN.md](JAWABAN.md), screenshot bukti
di [docs/screenshots](docs/screenshots).
