# MyMovies

> Aplikasi Android untuk melihat daftar film terbaru di seluruh dunia, dibangun menggunakan Flutter dan terintegrasi dengan API The Movie Database (TMDb).

---

## Daftar Isi

- [Tech Stack](#tech-stack)
- [Struktur Proyek](#struktur-proyek)
- [Halaman Aplikasi](#halaman-aplikasi)
- [Fitur Utama](#fitur-utama)
- [Prasyarat](#prasyarat)
- [Konfigurasi API](#konfigurasi-api)
- [Menjalankan Proyek](#menjalankan-proyek)
- [Akun Demo](#akun-demo)
- [Dependensi](#dependensi)
- [Developer](#developer)

---

## Tech Stack

| Teknologi | Keterangan |
|-----------|------------|
| Flutter | Cross-platform UI framework |
| Dart | Bahasa pemrograman utama |
| Provider | State management |
| HTTP | HTTP client untuk koneksi API |
| Shared Preferences | Penyimpanan data lokal (favorit) |
| Intl | Format tanggal & angka (lokal Indonesia) |
| TMDb API | Sumber data film |

---

## Struktur Proyek

```
lib/
│
├── main.dart
│
├── core/
│   ├── constants/
│   │   └── api_constants.dart       # Base URL, API key, headers
│   ├── routes/
│   │   └── app_routes.dart          # Named routes
│   └── theme/
│       └── app_theme.dart           # Dark theme & color palette
│
├── models/
│   └── movie.dart                   # Model data film + Genre
│
├── services/
│   └── tmdb_service.dart            # HTTP client ke TMDb API
│
├── providers/
│   ├── movie_provider.dart          # State film (fetch, search, pagination)
│   └── favorite_provider.dart       # State favorit (persistent storage)
│
├── pages/
│   ├── login/
│   │   └── login_page.dart          # Halaman login
│   ├── home/
│   │   └── home_page.dart           # Halaman utama + bottom nav
│   ├── detail/
│   │   └── detail_page.dart         # Detail film
│   ├── search/
│   │   └── search_page.dart         # Pencarian film
│   └── favorite/
│       └── favorite_page.dart       # Daftar film favorit
│
├── widgets/
│   ├── movie_card.dart              # Card & list tile film
│   ├── movie_grid.dart              # Grid & horizontal list film
│   └── custom_textfield.dart        # Input field & search field
│
└── utils/
    └── helper.dart                  # Format tanggal, angka, validasi
```

---

## Halaman Aplikasi

| Halaman | Deskripsi |
|---------|-----------|
| Login | Autentikasi pengguna dengan validasi form |
| Home | Daftar film (Sedang Tayang, Segera Tayang, Populer) |
| Detail | Informasi lengkap film yang dipilih |
| Search | Pencarian film dengan debounce real-time |
| Favorit | Koleksi film yang telah di-bookmark |

---

## Fitur Utama

### Autentikasi
- Login dengan email dan password
- Validasi format email
- Tampilkan/sembunyikan password
- Animasi transisi halaman login

### Halaman Utama
- Tampilan horizontal scroll "Sedang Tayang" dan "Segera Tayang"
- Grid dua kolom untuk film populer
- Infinite scroll / pagination otomatis
- Pull-to-refresh
- Bottom navigation bar dengan badge jumlah favorit

### Detail Film
- Backdrop image fullscreen
- Informasi lengkap: rating, durasi, genre, sinopsis, budget, pendapatan
- Tombol favorit terintegrasi
- Sinopsis dengan expand/collapse
- Format mata uang dan tanggal dalam bahasa Indonesia

### Pencarian
- Pencarian real-time dengan debounce 500ms
- Tampilan jumlah hasil pencarian
- Chip saran kata kunci
- Empty state & no result state yang informatif

### Favorit
- Simpan & hapus film favorit
- Persistent storage menggunakan SharedPreferences
- Swipe-to-delete dengan fitur undo
- Dialog konfirmasi hapus semua
- Empty state dengan tombol navigasi ke Home

---

## Prasyarat

Pastikan perangkat lunak berikut sudah terinstal:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) >= 3.19.0
- [Dart SDK](https://dart.dev/get-dart) >= 3.0.0
- [Android Studio](https://developer.android.com/studio) atau [VS Code](https://code.visualstudio.com/)
- Android Emulator atau perangkat fisik Android

Verifikasi instalasi:

```bash
flutter --version
dart --version
flutter doctor
```

---

## Konfigurasi API

Daftarkan akun di [The Movie Database (TMDb)](https://www.themoviedb.org/) untuk mendapatkan API key.

Setelah mendapatkan key, ubah file berikut:

```
lib/core/constants/api_constants.dart
```

```dart
static const String apiKey = 'GANTI_DENGAN_API_KEY_KAMU';
static const String readAccessToken = 'GANTI_DENGAN_READ_ACCESS_TOKEN_KAMU';
```

> **Penting:** Jangan pernah meng-commit API key asli ke repositori publik. Pertimbangkan menggunakan file `.env` untuk produksi.

---

## Menjalankan Proyek

### 1. Clone Repositori

```bash
git clone <your_repository_url>
cd mymovies
```

### 2. Install Dependensi

```bash
flutter pub get
```

### 3. Jalankan Aplikasi

```bash
# Mode debug
flutter run

# Mode release
flutter run --release

# Pilih device spesifik
flutter run -d <device_id>

# Lihat daftar device
flutter devices
```

### 4. Build APK

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release
```

Output APK tersedia di: `build/app/outputs/flutter-apk/`

---

## Akun Demo

Aplikasi menggunakan autentikasi dummy untuk keperluan pengembangan:

| Field | Value |
|-------|-------|
| Email | `admin@mymovies.com` |
| Password | `admin123` |

> Ganti logika autentikasi di `lib/utils/helper.dart` → fungsi `validateLogin()` untuk integrasi dengan API auth sesungguhnya.

---

## Dependensi

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2           # State management
  http: ^1.2.2               # HTTP client
  shared_preferences: ^2.3.2 # Local storage
  intl: ^0.19.0              # Format tanggal & angka
```

---

## Developer

**Varell Abdul Rozaq Khudhori**

Dibangun menggunakan Flutter dan The Movie Database (TMDb) API.
