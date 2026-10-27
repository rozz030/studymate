# StudyMate - Mobile Application Mini Project

Aplikasi pendamping belajar berbasis **Flutter** untuk mencari referensi pembelajaran, menyimpan materi favorit, dan mengelola catatan belajar terstruktur dengan arsitektur bersih (*Clean Architecture*).

Project ini dibangun sebagai pemenuhan **Project Ujian Tengah Semester (UTS) Pemrograman Mobile**.

---

## Identitas Mahasiswa

- **Nama**: Komang Rossi Adi Utama
- **NIM**: 2415051106
- **Kelas**: PTI 5A
- **Program Studi**: Pendidikan Teknik Informatika
- **Dosen Pengampu**: Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom
- **Teaching Assistant**: Made Yuda Sadewa, S.Pd.

---

## Fitur Utama & Screens

Aplikasi memiliki **8 Screen Fungsional** (memenuhi ketentuan minimal 6 screen):

1. **Home / Dashboard (`HomePage`)**
   - Ringkasan aktivitas dan inspirasi belajar (*Study Tip*).
   - Akses cepat (*Quick Access*) langsung menuju Explore, Saved, dan Notes.
   - Statistik real-time jumlah referensi tersimpan dan jumlah catatan.
   - Kategori topik pembelajaran dan rekomendasi referensi.
2. **List / Catalog (`ExplorePage`)**
   - Integrasi REST API Open Library dengan *live search*.
   - Filter cepat berdasarkan topik (*Programming, Algorithm, Database, Design*).
   - Penyesuaian layout responsif (*Compact ListView* vs *Wide GridView*).
   - Indikator lengkap: *Loading State, Error State (Retry),* dan *Empty State*.
3. **Detail Referensi (`StudyDetailPage`)**
   - Menampilkan cover, judul lengkap, penulis, tahun terbit, dan sumber.
   - *Passing data* objek model antar-screen.
   - Tombol toggle Simpan / Hapus Referensi ke Supabase.
   - **Fitur Kreativitas**: Tombol *Open in Open Library* via `url_launcher` untuk membuka sumber pustaka asli di browser.
4. **Create / Add Note (`AddNotePage`)**
   - Form pembuatan catatan belajar baru dengan validasi form wajib isi.
   - Dropdown pilihan kategori (*Materi, Tugas, Rangkuman, Ide*).
   - Dropdown tingkat prioritas (*Low, Medium, High*).
   - Feedback user menggunakan floating *SnackBar* setelah penyimpanan berhasil.
5. **Edit Note (`EditNotePage`)**
   - Memperbarui data catatan yang sudah ada dengan *passing data* objek `StudyNote`.
   - Mengubah judul, isi, kategori, dan prioritas secara real-time ke Supabase.
   - Indikator loading saat menyimpan perubahan dan notifikasi *SnackBar*.
6. **Favorites / Saved (`SavedPage`)**
   - Menampilkan daftar referensi belajar yang disimpan oleh user di database Supabase.
   - Fitur hapus langsung dari daftar dengan feedback *SnackBar*.
   - Navigasi kembali ke detail referensi.
7. **Notes List (`NotesPage`)**
   - Daftar catatan belajar yang terintegrasi penuh secara CRUD dengan Supabase.
   - Dialog konfirmasi penghapusan (*AlertDialog*) sebelum data dihapus permanen.
   - Floating Action Button menuju `AddNotePage`.
8. **Profile & About (`ProfilePage`)**
   - Menampilkan identitas mahasiswa lengkap (Nama, NIM, Kelas, Avatar).
   - Statistik total referensi tersimpan dan total catatan secara real-time via Provider.
   - Dialog informasi detail pengembang dan informasi versi aplikasi.

---

## Tech Stack

- **Framework**: Flutter (v3.x / Dart v3.x)
- **UI & Design**: Material Design 3, Responsive LayoutBuilder & MediaQuery
- **State Management**: `provider` (ChangeNotifier)
- **Networking**: `http`
- **Backend & Database**: `supabase_flutter` (PostgreSQL Database)
- **External Integration**: `url_launcher` (membuka tautan Open Library)

---

## REST API yang Digunakan

- **Penyedia API**: [Open Library API](https://openlibrary.org/)
- **Endpoint**: `https://openlibrary.org/search.json`
- **Method**: `GET`
- **Parameter**:
  - `q`: Kata kunci pencarian judul/materi buku
  - `limit`: Batasan hasil (20 item)
  - `fields`: `key,title,author_name,first_publish_year,cover_i,editions`
- **Model Parser**: `StudyMaterial.fromJson(Map<String, dynamic> json)`

---

## Backend & Database (Supabase)

Backend menggunakan **Supabase PostgreSQL** tanpa menyimpan credential sensitif (`service_role` tidak digunakan, hanya `anon/publishableKey`).

### 1. Tabel Utama: `study_notes` (Operasi Penuh CRUD)
| Kolom | Tipe Data | Keterangan |
|---|---|---|
| `id` | `BIGINT / SERIAL` | Primary Key |
| `title` | `TEXT` | Judul catatan belajar |
| `content` | `TEXT` | Isi lengkap catatan |
| `category` | `TEXT` | Kategori (Materi, Tugas, dll.) |
| `priority` | `TEXT` | Prioritas (Low, Medium, High) |
| `created_at` | `TIMESTAMPTZ` | Waktu pembuatan catatan |

### 2. Tabel Tambahan: `saved_references`
| Kolom | Tipe Data | Keterangan |
|---|---|---|
| `id` | `BIGINT / SERIAL` | Primary Key |
| `reference_id`| `TEXT` | Key ID buku dari Open Library |
| `title` | `TEXT` | Judul buku referensi |
| `author` | `TEXT` | Nama pengarang/penulis |
| `publish_year`| `INTEGER` | Tahun pertama terbit |
| `cover_url` | `TEXT` | URL gambar cover buku |
| `source` | `TEXT` | Sumber data (Open Library) |
| `created_at` | `TIMESTAMPTZ` | Waktu disimpan |

---

## Arsitektur Aplikasi (Layered Architecture)

Aplikasi menerapkan pemisahan tanggung jawab secara ketat (*Separation of Concerns*):
```text
UI / Screens
     ↓
State / Provider (StudyProvider, NoteProvider)
     ↓
Repository (StudyMaterialRepository, SavedReferenceRepository, StudyNoteRepository)
     ↓
Service / Data Source (OpenLibraryService, SavedReferenceService, StudyNoteService)
     ↓
REST API (Open Library) / Database (Supabase)
```

### Struktur Folder Project:
```text
lib/
├── config/
│   └── supabase_config.dart
├── models/
│   ├── study_material.dart
│   └── study_note.dart
├── services/
│   ├── open_library_service.dart
│   ├── saved_reference_service.dart
│   └── study_note_service.dart
├── repositories/
│   ├── study_material_repository.dart
│   ├── saved_reference_repository.dart
│   └── study_note_repository.dart
├── providers/
│   ├── study_provider.dart
│   └── note_provider.dart
├── screens/
│   ├── home_page.dart
│   ├── explore_page.dart
│   ├── study_detail_page.dart
│   ├── add_note_page.dart
│   ├── edit_note_page.dart
│   ├── saved_page.dart
│   ├── notes_page.dart
│   └── profile_page.dart
├── widgets/
│   ├── empty_state_widget.dart
│   ├── error_state_widget.dart
│   ├── loading_widget.dart
│   ├── section_header.dart
│   └── study_material_card.dart
└── main.dart
```

---

## Screenshot Aplikasi

| Home / Dashboard | Explore (Katalog) | Detail Referensi |
|:---:|:---:|:---:|
| *(Screenshot Home)* | *(Screenshot Explore)* | *(Screenshot Detail)* |

| Tambah Catatan (Create) | Edit Catatan (Update) | Daftar Catatan (Delete & Read) |
|:---:|:---:|:---:|
| *(Screenshot Add)* | *(Screenshot Edit)* | *(Screenshot Notes)* |

| Saved References | Profile Mahasiswa | Responsive Tablet View |
|:---:|:---:|:---:|
| *(Screenshot Saved)* | *(Screenshot Profile)* | *(Screenshot Tablet)* |

---


---

## Minimum Requirement Checklist (UTS Pemrograman Mobile)

| Komponen | Spesifikasi Minimum | Implementasi pada StudyMate | Status |
|---|---|---|:---:|
| **Screen fungsional** | ≥ 6 Screen | 8 Screen fungsional (Home, Explore, Detail, Add Note, Edit Note, Saved, Notes, Profile) | ✅ Terpenuhi |
| **Dart Model** | ≥ 2 Model | 2 Model data (StudyMaterial, StudyNote) dengan JSON serialization & parsing | ✅ Terpenuhi |
| **Reusable Widget** | ≥ 3 Widget | 5 Reusable Widget (EmptyStateWidget, ErrorStateWidget, LoadingWidget, SectionHeader, StudyMaterialCard) | ✅ Terpenuhi |
| **Responsive condition** | ≥ 2 Kondisi | Compact & Wide/Expanded layout (LayoutBuilder, adaptive ListView & 2/4-column GridView) | ✅ Terpenuhi |
| **REST API** | ≥ 1 REST API | Open Library Search API (https://openlibrary.org/search.json) | ✅ Terpenuhi |
| **REST GET** | Wajib | Operasi http.get dengan error handling, timeout, dan JSON mapping ke model | ✅ Terpenuhi |
| **Backend database** | ≥ 1 Database | Supabase (PostgreSQL Cloud Database) | ✅ Terpenuhi |
| **Tabel database** | ≥ 1 Tabel | 2 Tabel database (study_notes sebagai tabel utama, saved_references sebagai bookmark) | ✅ Terpenuhi |
| **Field tabel** | ≥ 4 + ID | 5 Field + ID (id, 	itle, content, category, priority, created_at) | ✅ Terpenuhi |
| **CRUD database** | 4 Operasi | Create (Add Note), Read (List Notes), Update (Edit Note), Delete (Hapus Note) | ✅ Terpenuhi |
| **State management** | Provider / Ekuivalen | Provider + ChangeNotifier (StudyProvider, NoteProvider, MultiProvider) | ✅ Terpenuhi |
| **Multi-screen navigation** | Wajib | NavigationBar (5 tabs) + Navigator push/pop multi-level | ✅ Terpenuhi |
| **Passing data** | Wajib | Passing object model (StudyMaterial ke Detail, StudyNote ke Edit) | ✅ Terpenuhi |
| **Form + validation** | Wajib | Form validation di Add Note & Edit Note (Title, Content, Dropdown) | ✅ Terpenuhi |
| **SnackBar / Dialog** | Wajib | SnackBar feedback operasi & AlertDialog konfirmasi hapus catatan | ✅ Terpenuhi |
| **Loading state** | Wajib | Indikator loading pada pencarian API, database fetch, & form submit | ✅ Terpenuhi |
| **Error state** | Wajib | Error state widget dengan tombol retry & exception handling terstruktur | ✅ Terpenuhi |
| **Empty state** | Wajib | Empty state informatif pada hasil pencarian, saved references, & notes | ✅ Terpenuhi |
| **Meaningful Git commits** | ≥ 16 Commits | 17+ meaningful commits terstruktur mengikuti milestone pengembangan | ✅ Terpenuhi |
| **Push per milestone** | Wajib | Commit & Push bertahap ke remote GitHub repository | ✅ Terpenuhi |
| **README** | Wajib | Dokumentasi lengkap memuat seluruh spesifikasi, arsitektur, & panduan | ✅ Terpenuhi |
| **GitHub URL** | Wajib | Repository publik GitHub aktif | ✅ Terpenuhi |

---

## Cara Menjalankan Project

1. **Clone repository ini**:
   ```bash
   git clone https://github.com/rozz030/studymate.git
   cd studymate
   ```

2. **Pastikan Flutter SDK terpasang**:
   ```bash
   flutter doctor
   ```

3. **Unduh dependencies paket**:
   ```bash
   flutter pub get
   ```

4. **Jalankan aplikasi**:
   ```bash
   flutter run
   ```