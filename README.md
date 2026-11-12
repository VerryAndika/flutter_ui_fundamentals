# Flutter UI Fundamentals – Learning Dashboard & Course Explorer

Praktikum Pertemuan 4, 5, 6, dan 7 Pemrograman Mobile.

**2415051065 - I Kadek Very Andika** (5 IKI)

Aplikasi Flutter yang dikembangkan bertahap setiap pertemuan:

- **P4** – Learning Dashboard dari file JSON statik (`assets/data/student_data.json`).
- **P5** – Course Explorer dengan navigasi responsif (NavigationBar / NavigationRail).
- **P6** – Course Explorer v2 dengan Provider, repository, dan favorites.
- **P7** – **Course Data Manager**: data course dibaca dan dikelola (CRUD) dari
  backend **Supabase (PostgreSQL)**; versi REST API latihan tetap tersedia.

## Menjalankan

```bash
flutter pub get
flutter run            # emulator/device
flutter run -d chrome  # atau di browser
flutter test
```

Aplikasi langsung terhubung ke project Supabase latihan (URL dan *publishable key*
ada di `lib/config/supabase_config.dart`). Untuk memakai project Supabase sendiri:
jalankan `docs/supabase_schema.sql` di SQL Editor, lalu ganti URL dan publishable key
pada file tersebut. Untuk kembali ke REST API latihan, ganti satu baris data source
di `lib/main.dart` menjadi `CourseApiService(apiBaseUrl)`.

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

Jawaban worksheet: [JAWABAN.md](JAWABAN.md) (P4), [JAWABAN_P5.md](JAWABAN_P5.md) (P5),
[JAWABAN_P6.md](JAWABAN_P6.md) (P6), dan [JAWABAN_P7.md](JAWABAN_P7.md) (P7).
Screenshot bukti: [docs/screenshots](docs/screenshots) dan [docs/p5](docs/p5).

## Pertemuan 6 – State Management & Architecture

Project Pertemuan 5 dilanjutkan dan direfactor menjadi **Course Explorer v2**
(Provider, model, service, repository). Latihan per tahap ada di route `/p6/tahapN`. Jawaban: [JAWABAN_P6.md](JAWABAN_P6.md), screenshot: [docs/p6](docs/p6).

### Arsitektur Course Explorer v2

Arah dependency: **Screen/Widget → Provider → Repository → Service → JSON asset**.

| Folder | Tanggung jawab |
|---|---|
| `lib/models/` | Representasi data (`Course` + `Course.fromJson`). Tidak bergantung pada Flutter. |
| `lib/services/` | Detail akses data: membaca `assets/data/student_data.json` dengan `rootBundle` + `jsonDecode` (`CourseService`). |
| `lib/repositories/` | Abstraksi sumber data untuk provider (`CourseRepository.getCourses()`); bisa diganti API tanpa mengubah UI. |
| `lib/providers/` | State + aksi (`CourseProvider`: courses, loading/error, favorites, `notifyListeners`). Tidak berisi widget atau `BuildContext`. |
| `lib/screens/` | Halaman: `HomeShell` (navigasi responsif), Home, Courses, Detail, Favorites, Profile. Hanya membaca provider. |
| `lib/widgets/` | Komponen UI yang dipakai ulang (`CourseCard`, `IdentityHeader`). |
| `lib/p6/stages/` | Latihan per tahap Pertemuan 6 (route `/p6/tahapN`). |
| `lib/p5/`, `lib/pages/` | Hasil Pertemuan 5 dan 4 yang dipertahankan sebagai riwayat (route `/p5`, `/p4`). |

Audit (Tahap 16): screen/widget/provider tidak memanggil `rootBundle`/`jsonDecode`;
model, service, repository, dan provider tidak mengimpor widget maupun `BuildContext`.

## Pertemuan 7 – REST API, Backend Services & Database

Course Explorer v2 dikembangkan menjadi **Course Data Manager** (bukan project baru):
data course diambil dari REST API lalu dari database Supabase, dengan CRUD lengkap.
Latihan per tahap ada di route `/p7/tahapN`.

### Endpoint REST yang digunakan (Tahap 1)

Base URL (`apiBaseUrl`): `https://course-api-pearl.vercel.app` — API latihan dari dosen
(koleksi Postman *Course API - Pertemuan 7*). Data dipakai bersama satu kelas.

| Method | Endpoint | Status sukses | Keterangan |
|---|---|---|---|
| GET | `/courses` | 200 | Semua course, urut berdasarkan `id` (opsional `?status=planned\|active\|done`) |
| GET | `/courses/{id}` | 200 | Satu course; 404 jika tidak ada, 400 jika id bukan angka |
| POST | `/courses` | 201 | Buat course (`code`, `title`, `credits` wajib; `status` default `planned`); 409 jika `code` duplikat |
| PUT | `/courses/{id}` | 200 | Ganti seluruh data course |
| PATCH | `/courses/{id}` | 200 | Ubah sebagian field |
| DELETE | `/courses/{id}` | 204 | Hapus course, tanpa body |

Field JSON resource course: `id` (int), `code` (string), `title` (string), `credits` (int),
`status` (`planned`/`active`/`done`), `created_at` (timestamp ISO-8601).
Error dikembalikan sebagai JSON `{"error": "...", "status": <kode>}`.

### Database Supabase (Tahap 10–11)

Project: **course-data-manager** — `https://vebwsoctgginxbkqcamt.supabase.co`
(aplikasi memakai *publishable key*; secret key / service_role **tidak** ada di repo).

Tabel `public.courses` — SQL lengkap di [docs/supabase_schema.sql](docs/supabase_schema.sql):

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | bigint identity | Primary key |
| `code` | text, unique | Kode course (juga kunci favorites) |
| `title` | text | Judul course |
| `credits` | int, `> 0` | Jumlah SKS |
| `status` | text, default `planned` | CHECK `planned` / `active` / `done` |
| `created_at` | timestamptz | Waktu pembuatan |

Nama kolom sama dengan key di `Course.fromJson()` / `toJson()`.
RLS aktif dengan policy permisif untuk role `anon` (select/insert/update/delete) —
**hanya untuk laboratorium**, bukan pola produksi.

### Arsitektur Course Data Manager (Tahap 16)

Arah dependency: **Screen/Widget → CourseProvider → CourseRepository → CourseDataSource**,
dengan dua implementasi data source:

| Data source | File | Dipakai |
|---|---|---|
| REST API | `lib/services/course_api_service.dart` (`http`) | Tahap 2–9 |
| Supabase | `lib/services/course_supabase_service.dart` (`supabase_flutter`) | Tahap 12–18 (**aktif**) |

Data source aktif dipilih **hanya** di `lib/main.dart`:

```dart
final CourseDataSource dataSource = CourseSupabaseService(); // REST: CourseApiService(apiBaseUrl)
```

Screen, provider, dan repository tidak berubah ketika sumber data diganti.
Fitur: list/grid responsif, detail, tambah (form + validasi), edit (code read-only),
hapus (dengan konfirmasi), refresh, loading/empty/error + retry, SnackBar, favorites (kunci `code`).

### Keamanan (Tahap 17)

- [x] Tidak ada `service_role` / secret key di source code — aplikasi hanya memakai *publishable key*.
- [x] Tidak ada password/token pribadi di repository (password database Supabase tidak disimpan di repo).
- [x] File `.env` diabaikan lewat `.gitignore`.
- [x] Screenshot tidak menampilkan key lengkap (UI menampilkan key yang disamarkan).
- [x] RLS aktif di tabel `courses`; policy permisif `anon` hanya untuk laboratorium.
- [x] Validasi di form hanya membantu pengguna — backend tetap menegakkan aturan
      (`UNIQUE(code)`, `CHECK(credits > 0)`, `CHECK(status in ...)`, RLS).

Pesan error yang ditampilkan aplikasi: 404/endpoint salah (REST), tidak ada koneksi,
format JSON tidak sesuai model, `23505` code duplikat, `23514` melanggar CHECK,
`42501` ditolak RLS, dan update/delete yang tidak mengubah baris apa pun.

### Backend yang digunakan

| Backend | Keterangan |
|---|---|
| Supabase (PostgreSQL) — **aktif** | `https://vebwsoctgginxbkqcamt.supabase.co`, tabel `courses`, RLS aktif |
| REST API latihan | `https://course-api-pearl.vercel.app/courses` (dipakai Tahap 1–9) |

Screenshot bukti P7: [docs/p7](docs/p7).
