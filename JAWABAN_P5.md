# Jawaban Worksheet Pertemuan 5 – Responsive Layout, Navigation & User Interaction

**2415051065 - I Kadek Very Andika** (5 IKI)

> Sesuaikan dengan bahasa Anda sendiri sebelum dikumpulkan.

## Peta tahap → file

| Tahap | File | Route |
|---|---|---|
| 1 | `lib/p5/stages/tahap01_hardcoded.dart` | `/p5/tahap1` |
| 2 | `lib/p5/stages/tahap02_mediaquery.dart` | `/p5/tahap2` |
| 3 | `lib/p5/breakpoints.dart`, `lib/p5/stages/tahap03_layoutbuilder.dart` | `/p5/tahap3` |
| 4 | `lib/p5/stages/tahap04_flexible_wrap.dart` | `/p5/tahap4` |
| 5 | `lib/p5/stages/tahap05_grid.dart`, `lib/p5/widgets/course_card.dart` | `/p5/tahap5` |
| 6 | `lib/p5/stages/tahap06_scroll.dart` | `/p5/tahap6-noscroll`, `/p5/tahap6` |
| 7 | `lib/p5/stages/tahap07_navigation.dart` | `/p5/tahap7` |
| 8–9 | `lib/p5/pages/course_detail_page.dart`, `lib/p5/stages/tahap08_course_list.dart` | `/p5/tahap8` |
| 10–11 | `lib/p5/responsive_shell.dart` | `/` (halaman utama) |
| 12 | `lib/p5/widgets/course_card.dart`, `lib/p5/stages/tahap12_interaction.dart` | `/p5/tahap12` |
| 13–14 | `lib/p5/widgets/feedback_form.dart` | `/p5/tahap13` |
| 15 | `lib/p5/pages/*` (Home, Courses, Profile) + shell | `/` |
| 16 | `lib/p5/stages/tahap16_debugging.dart` | `/p5/tahap16` |

Di Android, setiap route dapat dibuka dengan deep link `fuf://app/p5/tahap2`.

## Device yang dipakai
- **Emulator Android Pixel 6 (Android 17, API 37)**: tahap 1–4, 6–10, dan Courses compact (tahap 15).
- **Chrome (Flutter Web, mode debug)**: tahap 5 medium/expanded, 11–16. Emulator tidak stabil
  (crash/macet) setelah beberapa kali rotasi karena RAM laptop hanya ±7,5 GB, sehingga sisa bukti
  diambil di Chrome dengan viewport 412 (compact), 700 (medium), dan 1100 (expanded).
- Kasus C (keyboard) di Chrome disimulasikan dengan memperkecil tinggi viewport menjadi 480, karena
  Chrome desktop tidak punya keyboard virtual. Keyboard asli diuji di emulator pada Tahap 6.

## Tahap 1
Pada portrait (411 dp) `Container(width: 500)` di dalam `Row` overflow (garis kuning-hitam).
Pada landscape (914 dp) tidak overflow tetapi menyisakan ruang kosong di kanan. Dengan
`double.infinity`/`Expanded`, lebar mengikuti ruang yang tersedia di kedua orientasi.

**Jawaban:** ukuran hard-coded hanya cocok untuk satu ukuran layar; pada layar lebih kecil menyebabkan
overflow, pada layar lebih besar menyisakan ruang kosong, sedangkan device Android sangat beragam ukurannya.

## Tahap 2
Portrait: width 411, height 914, `Orientation.portrait` → *Compact*.
Landscape: width 914, height 411, `Orientation.landscape` → *Wide*.

## Tahap 6
Tanpa `SingleChildScrollView` muncul *BOTTOM OVERFLOWED*. Dengan scroll view, saat keyboard
terbuka (emulator) field paling bawah tetap terlihat dan halaman masih bisa di-scroll.
`ListView` lebih tepat untuk daftar panjang/dinamis karena item dibangun secara lazy, sedangkan
`SingleChildScrollView` membangun semua child sekaligus.

## Tahap 9 – contoh lain data hasil screen
Halaman filter mengembalikan kategori yang dipilih (`pop(context, 'Selesai')`), lalu halaman list
memfilter course sesuai hasil tersebut.

## Tahap 14 – SnackBar vs Dialog
SnackBar untuk info singkat yang tidak perlu respons (data tersimpan); Dialog untuk aksi penting
yang butuh keputusan pengguna sebelum lanjut (konfirmasi kirim/hapus).

## Tahap 16
- **A**: `Text` di `Row` mendapat lebar tak terbatas → overflow. `Expanded` memberi lebar sisa yang terbatas sehingga teks wrap.
- **B**: `ListView` di `Column` tanpa `Expanded` → *Vertical viewport was given unbounded height* (terlihat di console Chrome `docs/p5/p16_b_console.png` dan dibuktikan di `test/widget_test.dart`). `Expanded` memberi tinggi terbatas.
- **C**: form di bawah tanpa scroll → *BOTTOM OVERFLOWED* saat ruang vertikal berkurang; dibungkus `SingleChildScrollView`.
- **D**: tiga klik cepat mem-push lebih dari satu halaman detail (3 pada percobaan pertama, 2 pada pengambilan ulang). Diperbaiki dengan flag `navigating` sehingga hanya **1** yang terbuka. Di kasus nyata: nonaktifkan tombol selama proses, atau abaikan tap saat navigasi/request sedang berjalan.

## G. Refleksi
1. **MediaQuery vs LayoutBuilder**: MediaQuery membaca ukuran seluruh layar (dipakai di Tahap 2 dan kartu "Compact 411 dp" di Home); LayoutBuilder membaca constraints dari parent (dipakai di shell, grid course, dan Tahap 3) sehingga cocok untuk widget yang ruangnya lebih kecil dari layar, mis. area di samping NavigationRail.
2. **Hard-coded width/height**: tidak menyesuaikan ukuran layar dan orientasi, menyebabkan overflow atau ruang kosong.
3. **Constraints & RenderFlex overflow**: parent memberi batas maksimum; jika child (mis. Text panjang atau Container 500) meminta ukuran lebih besar dari batas itu di Row/Column, Flutter menandai overflow.
4. **Expanded vs Flexible**: Expanded saat child harus mengisi seluruh sisa ruang (panel 2:1); Flexible saat child boleh lebih kecil dari jatah ruangnya.
5. **Navigation stack**: push menaruh halaman baru di atas tumpukan, pop mengambil halaman teratas dan kembali ke halaman di bawahnya.
6. **Data lewat constructor**: halaman detail jelas kebutuhan datanya, bisa dipakai ulang untuk course mana pun, dan tidak bergantung pada variabel global.
7. **NavigationBar vs NavigationRail**: NavigationBar di bawah untuk layar sempit (jempol mudah menjangkau); NavigationRail di samping untuk layar lebar agar ruang vertikal tidak terpakai.
8. **InkWell vs GestureDetector**: InkWell untuk elemen Material yang perlu efek ripple (kartu course); GestureDetector untuk gesture umum tanpa efek visual (double tap kotak).
9. **Validasi input**: mencegah data kosong/salah diproses atau dikirim, dan memberi pesan yang jelas kepada pengguna.
10. **Error yang ditemui**: route P5 berubah menjadi `C:/Program Files/Git/p5/...` karena Git Bash mengonversi argumen berawalan `/`; ditemukan saat membaca `p5_routes.dart` setelah commit, lalu diperbaiki dan dicegah dengan `MSYS_NO_PATHCONV=1`.
