# Jawaban Worksheet Pertemuan 6 – State Management & Architecture

**2415051065 - I Kadek Very Andika** (5 IKI)

> Sesuaikan dengan bahasa Anda sendiri sebelum dikumpulkan.

Aplikasi dijalankan di Chrome (Flutter Web, mode debug); screenshot ada di [docs/p6](docs/p6). Latihan per tahap: route `/p6/tahapN`.

## Catatan per tahap

- **Tahap 0**: Project Pertemuan 5 (repo flutter_ui_fundamentals) dipakai sebagai basis, tidak membuat project baru. Working tree bersih, 5 commit terakhir adalah P5. flutter devices menemukan Chrome, Edge, dan Windows. Commit Tahap 0 menambah kerangka route /p6 dan catatan README.
- **Tahap 1**: 7 state diidentifikasi: 4 local (tab aktif, teks form, expand/collapse, loading kirim) dan 3 shared (daftar course, favorites, identitas). Switch "Tampilkan detail course" memakai setState() karena hanya dibutuhkan halaman itu.
- **Tahap 2**: Set favorites di parent diteruskan ke FavoriteSummary (constructor) dan ke CourseSection → CourseRow (constructor + callback). CourseSection tidak memakai favorites tetapi wajib menerima dan meneruskannya; semakin dalam widget tree, semakin panjang rantai parameter.
- **Tahap 3**: State favorite dimiliki LiftingStatePage. SimpleCourseCard menerima isFavorite dan mengirim aksi lewat onFavoriteChanged; FavoriteBadge membaca nilai yang sama, sehingga setelah ditekan keduanya konsisten menampilkan "Favorite: YA".
- **Tahap 4**: Tombol ValueNotifier ditekan 3x dan setState 2x. Build halaman tercatat 3 kali (1 awal + 2 setState): tiga perubahan ValueNotifier tidak membangun ulang halaman, hanya ValueListenableBuilder. Hitungan builder tertulis 5 karena builder juga ikut dibangun saat setState membangun ulang halaman, dan angkanya dicetak oleh halaman sehingga tertinggal satu.
- **Tahap 5**: CourseProvider extends ChangeNotifier berisi Set favorites, toggleFavorite(), isFavorite(), dan favoriteCount; notifyListeners() dipanggil setelah Set berubah. Halaman demo mendengarkan dengan ListenableBuilder, dua course ditandai favorite.
- **Tahap 6**: provider: ^6.1.5+1 ditambahkan dengan flutter pub add/pub get. main() membungkus MyApp dengan ChangeNotifierProvider, dan halaman Tahap 6 berhasil membaca CourseProvider dengan context.watch.
- **Tahap 7**: Sebelum: watch menampilkan 0 favorite. Setelah tombol MOB05 ditekan: FavoriteCountTile (watch) dan semua Consumer ikut rebuild (build ke-2), sedangkan "Widget tanpa listen" dan daftar course (read) tetap build ke-1.
- **Tahap 8**: lib/models/course.dart berisi code, title, credits, status, progress dan factory Course.fromJson. Satu item JSON MOB03 diubah menjadi object Course lalu ditampilkan (status active → label "Berjalan").
- **Tahap 9**: rootBundle.loadString() dan jsonDecode() dipindah ke lib/services/course_service.dart yang mengembalikan List<Course>. Diuji langsung di halaman Tahap 9; console browser mencetak debugPrint "CourseService: 6 course dimuat".
- **Tahap 10**: lib/repositories/course_repository.dart menerima CourseService lewat constructor dan menyediakan getCourses(). Halaman Tahap 10 mengambil data lewat repository: UI → CourseRepository → CourseService → JSON.
- **Tahap 11**: CourseProvider menerima repository dan menyimpan courses, isLoading, error, serta status initial/loading/success/error. Setelah hot restart, layar menampilkan CircularProgressIndicator ±0,8 detik (delay simulasi di service) lalu daftar 6 course; saat path JSON salah, pesan error + tombol Coba lagi.
- **Tahap 12**: Dibuat folder providers/, screens/, dan widgets/ (models/, services/, repositories/ sudah dibuat di tahap 8–10). course_provider, courses_screen, dan course_card dipindah dengan git mv, seluruh import diperbaiki, analyzer bersih dan aplikasi tetap berjalan.
- **Tahap 13**: Dua course ditandai favorite dari Courses. Detail Flutter UI Fundamentals menampilkan Favorite: Ya, dan FavoritesScreen hanya menampilkan dua course tersebut—semuanya membaca CourseProvider yang sama.
- **Tahap 14**: Course Explorer v2: HomeShell (Home, Courses, Favorites, Profile) dengan NavigationBar di compact/medium dan NavigationRail di expanded; grid 1/2/3 kolom. Data lewat Provider → Repository → Service, loading/error/success ditangani, favorites konsisten di Courses, Detail, Favorites, dan Home. 10 widget test lulus.
- **Tahap 15**: A: notifyListeners() dikomentari lalu hot reload → tombol REST API ditekan tetapi ikon & jumlah tidak berubah; setelah dikembalikan, jumlah langsung 4. B: context.watch di atas ChangeNotifierProvider → ProviderNotFoundException (layar merah), diperbaiki dengan Builder. C: path di CourseService diubah → error state "Unable to load asset", lalu dikembalikan. D: setState setelah halaman ditutup → "setState() called after dispose()", diperbaiki dengan cek mounted.
- **Tahap 16**: Audit grep: screen, widget, dan provider tidak memanggil rootBundle/jsonDecode (hanya CourseService); models, services, repositories, dan providers tidak mengimpor widget atau BuildContext; import mengikuti arah Provider → Repository → Service → Model. Tanggung jawab tiap folder ditulis di README.

## Pertanyaan tahap

- **Tahap 1 – Mengapa tidak semua state perlu dikelola Provider?** Karena banyak state hanya dipakai satu widget (switch detail, teks form, tab aktif). Memasukkannya ke Provider menambah kode dan membuat rebuild lebih luas tanpa manfaat; setState() lebih sederhana dan cukup untuk state lokal.
- **Tahap 2 – Apa yang dimaksud prop drilling pada contoh Anda?** Di PropDrillingPage, Set favorites milik parent harus diteruskan lewat CourseSection ke CourseRow beserta callback onToggle, padahal CourseSection sendiri tidak memakai favorites—ia hanya "mengoper" data ke level di bawahnya.
- **Tahap 7 – Mengapa onPressed lebih cocok memakai read() daripada watch()?** onPressed hanya menjalankan aksi (toggleFavorite) dan tidak perlu menampilkan nilai provider. watch() di dalam callback akan mendaftarkan listener di luar fase build (menimbulkan error) dan tidak berguna; read() mengambil object tanpa listen.
- **Tahap 10 – Apa keuntungan repository jika sumber data diganti ke API?** Provider dan screen tetap memanggil repository.getCourses(). Yang diganti hanya implementasi service/repository (misalnya CourseApiService dengan http), sehingga UI dan state tidak perlu diubah.
- **Tahap 15 – Apa langkah pertama ketika data state berubah tetapi UI tidak ikut berubah?** Memastikan method yang mengubah state memanggil notifyListeners(), lalu memeriksa apakah widget membaca state dengan watch/Consumer (bukan read) dan berada di bawah ChangeNotifierProvider yang sama—seperti terlihat pada Kasus A.

## Refleksi

1. **Perbedaan local state dan shared state**: Local state hanya dibutuhkan satu widget dan cukup dikelola dengan setState() (switch detail, tab aktif). Shared state dipakai beberapa widget/screen (daftar course, favorites) sehingga dikelola satu provider.
2. **Mengapa setState() tetap berguna walaupun memakai Provider**: Untuk state lokal yang tidak perlu dibagi, setState() paling sederhana dan rebuild-nya terbatas pada widget itu, misalnya tab aktif di HomeShell dan status muat di Kasus D.
3. **Fungsi notifyListeners()**: Memberi tahu semua listener (watch, Consumer, ListenableBuilder) bahwa state berubah sehingga widget yang bergantung dibangun ulang. Tanpa notifyListeners() data berubah tetapi UI tidak ikut berubah (Kasus A).
4. **Perbedaan context.watch() dan context.read()**: watch() mendengarkan provider dan membuat widget rebuild ketika notifyListeners() dipanggil (jumlah favorite). read() hanya mengambil object tanpa listen, dipakai di onPressed untuk memanggil toggleFavorite().
5. **Arti single source of truth pada aplikasi**: Favorites hanya disimpan di CourseProvider. CourseCard, CourseDetailScreen, FavoritesScreen, dan Home membaca sumber yang sama, sehingga favorite yang ditandai di Courses langsung sama di Detail dan Favorites.
6. **Mengapa parsing JSON tidak dilakukan di screen**: Agar screen hanya fokus menampilkan data. Parsing di Course.fromJson dan CourseService membuat kode terpusat, bertipe jelas, mudah diuji, dan tidak perlu diubah di banyak screen jika format data berubah.
7. **Fungsi Repository**: Menjadi abstraksi antara CourseProvider dan sumber data. Provider cukup memanggil getCourses() tanpa tahu data berasal dari JSON asset; di test, repository diganti FakeCourseRepository.
8. **Alur data dari JSON hingga CourseCard**: assets/data/student_data.json → CourseService (rootBundle + jsonDecode + Course.fromJson) → CourseRepository.getCourses() → CourseProvider.loadCourses() (loading/error/courses) → CoursesScreen (watch) → CourseCard(course).
9. **Keuntungan folder terpisah saat JSON diganti API**: Cukup mengganti isi services/ (dan bila perlu repositories/); models, providers, screens, dan widgets tidak berubah karena hanya bergantung pada repository dan model Course.
10. **Bug state management yang ditemui**: Saat notifyListeners() dikomentari (Kasus A), menekan favorite tidak mengubah ikon maupun jumlah walaupun Set favorites berubah. Penyebabnya ditemukan dengan memeriksa method toggleFavorite(); setelah notifyListeners() dikembalikan dan hot reload, UI langsung menampilkan semua perubahan.
