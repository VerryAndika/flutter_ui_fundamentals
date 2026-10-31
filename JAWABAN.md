# Jawaban Worksheet Pertemuan 4 – Flutter UI Fundamentals

> Sesuaikan dengan bahasa Anda sendiri sebelum dikumpulkan.

## Peta tahap → file

| Tahap | Lokasi di project |
|---|---|
| 1–2 | `lib/main.dart`, `lib/identity.dart` |
| 3 | `pubspec.yaml` (bagian `assets:`), `assets/images/profile.jpg`, `assets/data/` |
| 4–7 | `lib/pages/practice_page.dart` (menu Drawer → Latihan Widget) |
| 8 | `lib/widgets/stat_card.dart` (`buildStatCard`), dipakai 3× di Latihan & Dashboard |
| 9 | `lib/widgets/greeting_card.dart` |
| 10–11 | `lib/pages/topics_page.dart` (menu Drawer → Daftar Topik) |
| 12 | `assets/data/student_data.json`, `lib/services/student_service.dart` |
| 13–14 | `lib/pages/dashboard_page.dart` + `lib/widgets/identity_card.dart`, `course_tile.dart` |
| 15 | `lib/pages/debugging_page.dart` (menu Drawer → Debugging) |

Field tambahan JSON (Tahap 14): `student.motto` dan `courses[].progress`
(ditampilkan sebagai kutipan di kartu profil dan progress bar di tiap materi).

## Tahap 1 – Eksperimen Hot Reload
Diuji dengan `flutter run -d chrome` (mode debug) di halaman `/tahap1`:
1. Tombol + ditekan 3 kali → counter **3**.
2. Teks `You have pushed the button this many times:` diubah, lalu **hot reload**
   (±1,5 detik): teks baru langsung tampil dan counter **tetap 3** (state dipertahankan).
3. **Hot restart** (±1,2 detik): aplikasi dijalankan ulang dari `main()` dan counter
   **kembali 0**. Stop lalu `flutter run` ulang juga mereset state, tetapi jauh lebih
   lama karena aplikasi dikompilasi dan dibuka ulang.

Bukti: `docs/screenshots/hr_1_before.png`, `hr_2_after_reload.png`, `hr_3_after_restart.png`.

## Tahap 2 – Pertanyaan Pemahaman
1. **Fungsi `main()`**: titik masuk program; fungsi pertama yang dijalankan saat aplikasi dibuka.
2. **Mengapa `runApp()` butuh Widget**: di Flutter seluruh UI adalah widget; `runApp()` menjadikan widget tersebut root dari widget tree yang digambar ke layar.
3. **MaterialApp vs Scaffold**: `MaterialApp` mengatur konfigurasi level aplikasi (tema, judul, navigasi/routing, halaman awal). `Scaffold` mengatur struktur satu layar (AppBar, body, drawer, FAB).

## Tahap 4 – Widget tree (versi project ini, halaman Latihan)
```
MaterialApp
└── Scaffold
    ├── AppBar → Text('Latihan Widget')
    └── SingleChildScrollView
        └── Column
            ├── Column (Tahap 4)
            │   ├── Text('$studentId - $studentName')
            │   ├── SizedBox
            │   ├── Text('Belajar Widget Tree')
            │   ├── SizedBox
            │   └── Icon(Icons.widgets)
            ├── ProfileAvatar, Text nama, Text NIM, Row(Icon, Text)   (Tahap 5)
            ├── Row → 3 × Column(Text angka, Text label)              (Tahap 6)
            ├── Card → Padding → Column, Container(BoxDecoration)      (Tahap 7)
            ├── Row → 3 × buildStatCard                                (Tahap 8)
            └── GreetingCard                                           (Tahap 9)
```

## Tahap 5 – Image.asset vs CircleAvatar
`CircleAvatar` lebih cocok untuk foto profil karena otomatis berbentuk lingkaran
dan berukuran konsisten, sedangkan `Image.asset` hanya menampilkan gambar apa adanya.

## Tahap 6 – Perbedaan MainAxisAlignment
- `spaceEvenly`: jarak sama di antara item **dan** di kedua tepi.
- `spaceBetween`: item pertama/terakhir menempel tepi, sisa ruang dibagi di antara item.
- `center`: semua item berkumpul di tengah tanpa jarak tambahan.

## Tahap 15 – Debugging
**Kasus A**: kode asli worksheet ada di route `/tahap15-overflow`; pada mode debug
muncul garis kuning-hitam *RIGHT OVERFLOWED* (`t15_overflow.png`). `Text` di dalam
`Row` diberi lebar tak terbatas, sehingga teks panjang melebihi lebar layar. Membungkus `Text` dengan `Expanded`
membuat Text hanya mendapat sisa lebar setelah Icon dan SizedBox, sehingga teks
otomatis turun baris.

**Kasus B** – tiga hal yang diperiksa saat *Unable to load asset*:
1. Nama/path file sama persis (termasuk huruf besar-kecil dan ekstensi).
2. Folder sudah didaftarkan di `pubspec.yaml` dengan indentasi YAML yang benar.
3. Sudah menjalankan `flutter pub get` dan **restart penuh** (bukan hot reload).

**Kasus C**: `studentDataPath` di `lib/services/student_service.dart` diubah
sementara menjadi `student_dat.json` lalu hot restart; dashboard menampilkan
*Gagal memuat data: Unable to load asset* (`t15_error.png`). Setelah path
dikembalikan dan hot restart lagi, data tampil normal (`t15_fixed.png`). Error state membuat aplikasi tetap tampil dengan
pesan yang jelas (plus tombol *Coba lagi*) alih-alih crash atau loading tanpa akhir,
sehingga pengguna dan developer tahu apa yang salah.

## E. Pertanyaan Refleksi
1. **"Everything is a Widget"**: semua elemen UI—teks, ikon, jarak, padding, layout, bahkan aplikasi itu sendiri—adalah widget yang disusun bertingkat membentuk widget tree.
2. **ListView di dalam Column perlu Expanded**: Column memberi tinggi tak terbatas ke anaknya, sedangkan ListView ingin memenuhi tinggi yang ada; tanpa batas muncul error *unbounded height*. `Expanded` memberi ListView sisa ruang yang terukur.
3. **Stateless vs Stateful**: `IdentityCard`, `CourseTile`, `TopicsPage` hanya menampilkan data yang diberikan (Stateless). `GreetingCard` dan `DashboardPage` punya data yang berubah (pesan input, future) sehingga Stateful dan memakai `setState()`.
4. **Data di JSON**: memisahkan data dari tampilan; data bisa diubah tanpa menyentuh kode UI, lebih rapi, dan polanya sama dengan data dari API nantinya.
5. **FutureBuilder & Future**: `loadStudentData()` mengembalikan `Future` (async/await dari materi Dart). FutureBuilder "mendengarkan" Future itu dan membangun UI sesuai status: menunggu, error, atau selesai dengan data.
6. **Inisialisasi di initState()**: `initState()` hanya dipanggil sekali, sedangkan `build()` bisa dipanggil berkali-kali. Jika future dibuat di `build()`, file JSON dimuat ulang dan loading muncul terus setiap rebuild.
7. **Fungsi `late`**: `studentFuture` non-null tetapi belum bisa diisi saat deklarasi; `late` menjanjikan bahwa nilainya pasti diisi (di `initState()`) sebelum pertama kali dibaca.
8. **Error yang ditemui**: (isi dengan pengalaman Anda, contoh) *RenderFlex overflow* pada Row teks panjang → membaca pesan error di debug console yang menunjuk widget Row, lalu membungkus Text dengan `Expanded`.

## Tahap 16 – Git
```bash
git init
git add .
git commit -m "Bangun Learning Dashboard Flutter dari JSON statik"
git branch -M main
git remote add origin https://github.com/USERNAME/flutter_ui_fundamentals.git
git push -u origin main
echo "NIM_ANDA - I Kadek Very Andika"
git log --oneline -6
```
Worksheet meminta commit **per tahap** — lebih baik commit setiap selesai satu tahap
saat Anda mengerjakan dan mengambil screenshot.
