// P7 Tahap 10: konfigurasi Supabase project latihan (course-data-manager).
//
// supabaseAnonKey adalah *publishable key* (sb_publishable_...): memang
// dirancang untuk dipakai di aplikasi client dan aman dibagikan selama RLS
// aktif. JANGAN pernah menaruh secret key / service_role key di sini.
const String supabaseUrl = 'https://vebwsoctgginxbkqcamt.supabase.co';
const String supabaseAnonKey = 'sb_publishable_3P6-bcijw--tOf1ErNyyRQ_eVNZ_Jl6';

// Untuk ditampilkan di UI/screenshot tanpa memperlihatkan key lengkap.
String get maskedSupabaseKey =>
    '${supabaseAnonKey.substring(0, 18)}…'
    '${supabaseAnonKey.substring(supabaseAnonKey.length - 4)}';
