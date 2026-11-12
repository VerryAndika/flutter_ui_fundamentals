# Jawaban Worksheet Pertemuan 7 – REST API, Backend Services & Database

**2415051065 - I Kadek Very Andika** (5 IKI)

Repository: https://github.com/VerryAndika/flutter_ui_fundamentals  
Backend: Supabase (PostgreSQL) + REST API latihan

## Tahap 1

- Endpoint: `GET https://course-api-pearl.vercel.app/courses`
- Status code: 200 OK
- Resource: courses (array JSON: id, code, title, credits, status)

## Catatan per tahap

| Tahap | Commit | Catatan |
|---|---|---|
| 0 | bdc7f90 | Melanjutkan repo Course Explorer v2 dari P6 (tidak membuat project baru). Package http ^1.6.0 ditambahkan dengan flutter pub add http, lalu flutter pub get berhasil. Remote origin mengarah ke VerryAndika/flutter_ui_fundamentals; Nama & NIM tetap tampil di aplikasi. |
| 1 | e840223 | Endpoint latihan dibuka lewat curl/Postman: GET /courses mengembalikan 200 dan array JSON dengan field id, code, title, credits, status. Endpoint lain (GET/PUT/DELETE /courses/:id, POST /courses) dicatat di README. Jika gagal, API mengirim JSON {"error", "status"}. |
| 2 | 0c6e6f6 | fetchCourses() memanggil http.get lalu memeriksa statusCode == 200 sebelum jsonDecode. Jumlah item tampil di UI dan debugPrint. Saat endpoint sengaja diganti /coursez, muncul Exception HTTP 404; setelah dikembalikan data tampil lagi. |
| 3 | 7dcf18b | Model Course diperbarui: id nullable, status default "planned" jika tidak dikirim API. toJson() hanya mengirim code/title/credits/status (id dibuat server). Response list dikonversi menjadi List<Course> dan ditampilkan (code, title, status). |
| 4 | 1b6f626 | Akses HTTP dipindah ke CourseApiService; CourseRepository sekarang bergantung pada service ini. lib/services/course_service.dart (P6) dihapus dengan git rm. Screen tidak lagi mengimpor package http; hasil tampilan sama seperti Tahap 3. |
| 5 | 6ef686a | CourseProvider memakai isLoading/error/courses yang sudah ada. CoursesScreen menampilkan loading, error (ErrorView + Retry), empty ("Data course belum tersedia"), dan success. loadCourses() dipanggil sekali di create Provider. Endpoint salah → error tampil, Retry setelah diperbaiki → data muncul. |
| 6 | 15540ea | Form Create (code, title, credits, status dropdown) dengan validasi wajib isi dan credits angka > 0. Alur POST: form → provider → repository → CourseApiService. Tombol Simpan nonaktif + spinner saat isSaving, mounted dicek setelah await, SnackBar tampil, lalu list di-reload (replace, bukan append). API membalas 201 Created. |
| 7 | 707284e | Tombol Edit di detail membuka form berisi data lama; field code read-only karena kunci favorites. Update dikirim dengan PUT /courses/:id, guard isSaving dan mounted sama seperti Tahap 6, lalu data di-refresh dan detail menampilkan nilai baru. |
| 8 | 7b9b0f8 | Hapus dari halaman detail memakai AlertDialog konfirmasi, lalu DELETE /courses/:id. Setelah berhasil course juga dikeluarkan dari favorites, SnackBar tampil, dan list di-refresh. Data uji yang dibuat sendiri sudah dihapus kembali dari API bersama. |
| 9 | dec2c5b | Dibuat abstract class CourseDataSource; CourseApiService implements kontrak ini dan CourseRepository menerima CourseDataSource. Perakitan service → repository → provider hanya di main.dart. Screen/provider tidak mengimpor http; GET/POST/PUT/DELETE diuji ulang dan tetap berjalan. |
| 10 | cbfc5ed | Dosen tidak membagikan project, jadi saya membuat project Supabase sendiri (course-data-manager, free plan). supabase_flutter ^2.18.3 ditambahkan; Supabase.initialize dipanggil sebelum runApp memakai publishableKey (parameter anonKey sudah deprecated). Hanya publishable key yang dipakai; di UI key ditampilkan tersamar. |
| 11 | acb520b | Tabel courses dibuat lewat SQL Editor: id identity PK, code UNIQUE, title, credits CHECK > 0, status CHECK in (planned, active, done) default planned, created_at. Lima data awal MOB01–MOB05. RLS aktif dengan 4 policy anon (select/insert/update/delete) — permisif khusus laboratorium, bukan produksi. SQL disimpan di docs/supabase_schema.sql. |
| 12 | 337eca6 + 49c9d6d | CourseSupabaseService (implements CourseDataSource) membaca select().order("id") dan mengonversi ke List<Course>; method lain sementara UnimplementedError. Pada commit pertama baris data source di main.dart belum ikut, sehingga ditambah commit lanjutan 49c9d6d (tanpa mengubah history). Data dari database tampil di list/grid bersama Nama & NIM. |
| 13 | e1fce62 | createCourse memakai insert(toJson()).select().single() sehingga tetap mengembalikan Course seperti versi REST — repository tidak berubah. Form Create yang sama dipakai; row baru terlihat di aplikasi dan di Table Editor Supabase. |
| 14 | 16ba79d | updateCourse(int id, Course) memakai update().eq("id", id).select(). Jika tidak ada baris yang berubah (id salah atau ditolak RLS), Supabase tidak menganggapnya error, jadi dibuat exception sendiri. Perubahan title/credits/status terlihat di UI dan dashboard. |
| 15 | 41626ba | deleteCourse memakai delete().eq("id", id).select() setelah dialog konfirmasi. Row hilang dari aplikasi dan dari tabel di dashboard; favorites ikut dibersihkan. |
| 16 | 6c0cb31 | Course Data Manager terintegrasi: sumber data aktif CourseSupabaseService (dipilih di main.dart). Ada SELECT, INSERT, UPDATE, DELETE + konfirmasi, loading/empty/error + retry, SnackBar, NavigationBar (<840 px) / NavigationRail (lebar), detail, dan favorites berbasis code yang tetap konsisten di Courses dan Favorites setelah refresh. |
| 17 | 0a9ff62 | A: endpoint /coursez → pesan HTTP 404 + Retry. B: offline (Network emulation) → REST menampilkan ErrorView "Failed to fetch" + Retry tanpa crash; client Supabase sempat mencoba ulang (loading) lalu pulih setelah online. C: key JSON diubah → TypeError ("type Null is not a subtype of String") tampil di ErrorView tanpa crash; di CourseSupabaseService TypeError kini dibungkus menjadi pesan "format data tidak sesuai". D: policy insert di-drop → INSERT ditolak 42501 (RLS), policy lalu dikembalikan. E: code duplikat MOB01 → 23505 UNIQUE. Pemeriksaan git grep: tidak ada service_role/secret, .env dan build/ diabaikan. |
| 18 | lihat `git log` (tag `pertemuan-7`) | README dilengkapi deskripsi, cara menjalankan, arsitektur, dan backend. Semua tahap punya commit terpisah dan sudah di-push; build/ dan credential tidak masuk repository. git log --oneline -12 ditampilkan; tag pertemuan-7 dibuat. |

## Pertanyaan Refleksi

**1. Apa perbedaan REST API, backend service, dan database?**

Database adalah tempat data disimpan secara persisten (misalnya tabel PostgreSQL). Backend service adalah program/layanan di server yang menjalankan logika, autentikasi, dan aturan akses ke database (contoh: Supabase). REST API adalah cara/antarmuka komunikasinya: client mengirim request HTTP ke endpoint resource (GET /courses, POST /courses) dan menerima response JSON. REST bukan tempat menyimpan data.

**2. Mengapa aplikasi Flutter tidak sebaiknya menyimpan credential database langsung?**

File aplikasi bisa dibongkar (decompile) sehingga apa pun yang ada di dalamnya dianggap publik. Jika password database atau service_role key tersimpan di aplikasi, siapa pun bisa membaca, mengubah, atau menghapus semua data tanpa batasan RLS. Karena itu aplikasi hanya memakai publishable/anon key dan aturan aksesnya ditegakkan di backend.

**3. Apa fungsi status code pada HTTP response?**

Status code memberi tahu hasil request sebelum body diproses: 2xx berhasil (200 OK, 201 Created), 4xx kesalahan dari sisi client (400 data tidak valid, 401/403 tidak berizin, 404 tidak ditemukan), dan 5xx kesalahan server. Aplikasi memeriksanya untuk memutuskan apakah body di-parse sebagai data atau ditampilkan sebagai error.

**4. Mengapa JSON sebaiknya dikonversi menjadi model Dart?**

Model memberi tipe yang jelas (int, String, int?) sehingga kesalahan nama key atau tipe terdeteksi di satu tempat (fromJson), editor bisa memberi autocomplete, dan kode UI tidak penuh akses Map dengan string. Nilai default (status = planned) dan konversi balik (toJson) juga cukup ditulis sekali.

**5. Apa keuntungan memindahkan HTTP/Supabase access ke service dan repository?**

Screen dan provider tidak perlu tahu detail jaringan, sehingga kode lebih rapi dan mudah diuji (repository bisa diberi data source palsu di test). Sumber data dapat diganti dari REST ke Supabase hanya dengan mengubah satu baris di main.dart, dan penanganan error backend terkumpul di satu tempat.

**6. Apa perbedaan loading, empty, dan error state?**

Loading berarti request masih berjalan, jadi ditampilkan indikator progres. Empty berarti request berhasil tetapi datanya kosong, jadi ditampilkan pesan "data belum tersedia". Error berarti request gagal (404, offline, format salah), jadi ditampilkan pesan penyebab dan tombol Retry.

**7. Apa perbedaan POST dengan PUT/PATCH?**

POST membuat resource baru pada koleksi (POST /courses) dan id-nya ditentukan server. PUT/PATCH memperbarui resource yang sudah ada berdasarkan id (PUT /courses/5): PUT mengganti seluruh data resource, sedangkan PATCH hanya mengubah field yang dikirim.

**8. Mengapa operasi DELETE sebaiknya memiliki konfirmasi user?**

DELETE bersifat destruktif dan biasanya tidak bisa dibatalkan, sementara tombol hapus mudah tersentuh tidak sengaja. Dialog konfirmasi yang menyebut nama course memberi kesempatan pengguna memastikan data yang benar sebelum benar-benar dihapus dari database.

**9. Apa fungsi RLS pada backend Supabase?**

Row Level Security adalah aturan otorisasi di PostgreSQL yang menentukan baris mana yang boleh dibaca atau diubah oleh setiap role/pengguna. Karena publishable key bersifat publik, RLS-lah yang benar-benar melindungi data. Saat policy insert saya hapus, INSERT dari aplikasi langsung ditolak dengan kode 42501.

**10. Jika sumber data diganti dari REST API ke Supabase, bagian mana yang idealnya berubah dan bagian mana yang tetap?**

Yang berubah hanya implementasi data source (CourseSupabaseService menggantikan CourseApiService), konfigurasi (URL/key, Supabase.initialize), dan satu baris pemilihan data source di main.dart. Model, repository, provider, dan seluruh screen tetap sama karena semuanya bergantung pada kontrak CourseDataSource.

## Kendala utama

Project Supabase dari dosen tidak tersedia sehingga dibuat project latihan sendiri (free plan); emulator Android tidak stabil pada RAM ±7.5 GB sehingga aplikasi dijalankan di Chrome (Flutter Web); satu commit Tahap 12 perlu commit lanjutan karena perubahan main.dart belum ikut.
