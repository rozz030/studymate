# StudyMate

StudyMate adalah aplikasi mobile berbasis Flutter yang dirancang sebagai teman belajar untuk membantu pengguna menemukan referensi pembelajaran, menyimpan referensi, dan mengelola catatan belajar secara terstruktur.

## Fitur Utama

### 1. Home
Halaman utama yang menampilkan ringkasan aktivitas belajar pengguna, statistik referensi tersimpan dan catatan, kategori pembelajaran, serta rekomendasi referensi.

### 2. Explore
Pengguna dapat mencari materi atau referensi pembelajaran menggunakan Open Library API.

Fitur yang tersedia:
- Pencarian referensi
- Menampilkan judul buku
- Menampilkan penulis
- Menampilkan tahun terbit
- Menampilkan cover buku
- Melihat detail referensi
- Menyimpan referensi

### 3. Saved
Halaman untuk melihat referensi pembelajaran yang telah disimpan oleh pengguna.

Data referensi tersimpan menggunakan Supabase sehingga data dapat dikelola melalui backend.

### 4. Notes
Pengguna dapat membuat dan mengelola catatan belajar.

Fitur Notes meliputi:
- Menambahkan catatan
- Mengedit catatan
- Menghapus catatan
- Menentukan kategori catatan
- Menentukan prioritas catatan
- Menyimpan data catatan ke Supabase

### 5. Profile
Halaman profil yang menampilkan informasi pengguna, jumlah referensi yang disimpan, jumlah catatan, informasi profil, dan informasi mengenai aplikasi StudyMate.

---

## Teknologi yang Digunakan

- **Flutter** — framework untuk pengembangan aplikasi mobile
- **Dart** — bahasa pemrograman
- **Provider** — state management
- **Supabase** — backend dan database
- **Open Library API** — sumber data referensi buku
- **HTTP** — komunikasi dengan Open Library API

---

## Arsitektur Aplikasi

StudyMate menggunakan arsitektur berlapis untuk memisahkan tanggung jawab setiap bagian aplikasi.

```text
UI / Screens
     ↓
Provider
     ↓
Repository
     ↓
Service
     ↓
External API / Supabase