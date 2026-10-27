import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/study_material.dart';
import '../models/study_note.dart';
import '../providers/note_provider.dart';
import '../providers/study_provider.dart';
import '../widgets/section_header.dart';
import 'explore_page.dart';
import 'saved_page.dart';
import 'notes_page.dart';
import 'add_note_page.dart';
import 'edit_note_page.dart';
import 'study_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _quickSearchController = TextEditingController();

  static const List<Map<String, dynamic>> categories = [
    {
      'title': 'Programming',
      'query': 'Programming',
      'description': 'Flutter, Dart, Python & Web',
      'icon': Icons.code_rounded,
      'color': Color(0xFF4F46E5), // Indigo
      'bg': Color(0xFFEEF2FF),
    },
    {
      'title': 'Algorithm',
      'query': 'Algorithm',
      'description': 'Logika & Problem Solving',
      'icon': Icons.account_tree_rounded,
      'color': Color(0xFF0D9488), // Teal
      'bg': Color(0xFFF0FDFA),
    },
    {
      'title': 'Database',
      'query': 'Database',
      'description': 'SQL, Supabase & Data Modeling',
      'icon': Icons.storage_rounded,
      'color': Color(0xFFD97706), // Amber
      'bg': Color(0xFFFFFBEB),
    },
    {
      'title': 'Design UI/UX',
      'query': 'Design',
      'description': 'Material 3 & Visual Design',
      'icon': Icons.palette_rounded,
      'color': Color(0xFF9333EA), // Purple
      'bg': Color(0xFFFAF5FF),
    },
  ];

  @override
  void dispose() {
    _quickSearchController.dispose();
    super.dispose();
  }

  void _submitSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    _quickSearchController.clear();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExplorePage(initialQuery: trimmed),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 700;
            final horizontalPadding = isTablet ? 36.0 : 20.0;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                20,
                horizontalPadding,
                36,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 18),
                      _buildSearchBar(context),
                      const SizedBox(height: 22),
                      _buildHero(context, isTablet),
                      const SizedBox(height: 24),
                      _buildQuickActions(context),
                      const SizedBox(height: 26),
                      _buildStatistics(context, isTablet),
                      const SizedBox(height: 32),
                      _buildRecentNotesSection(context),
                      const SizedBox(height: 32),
                      _buildSavedReferencesPreview(context),
                      const SizedBox(height: 32),
                      _buildCategorySection(context, isTablet),
                      const SizedBox(height: 30),
                      _buildStudyTip(context),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ==============================================================
  // 1. HEADER
  // ==============================================================

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.12),
                blurRadius: 16,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              'assets/images/app_logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      'Hai, Rossi 👋',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'PTI 5A',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                'Siap belajar apa hari ini?',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==============================================================
  // 2. QUICK SEARCH BAR (LANGSUNG CARI BUKU KE OPEN LIBRARY)
  // ==============================================================

  Widget _buildSearchBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _quickSearchController,
        textInputAction: TextInputAction.search,
        onSubmitted: _submitSearch,
        decoration: InputDecoration(
          hintText: 'Cari buku, topik kuliah, atau penulis...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.search_rounded,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
          suffixIcon: IconButton(
            tooltip: 'Cari di Open Library',
            onPressed: () => _submitSearch(_quickSearchController.text),
            icon: Icon(
              Icons.arrow_forward_rounded,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // 3. HERO BANNER
  // ==============================================================

  Widget _buildHero(BuildContext context, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 30 : 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF3730A3), // Deep Indigo
            Color(0xFF4F46E5), // Indigo
            Color(0xFF6366F1), // Soft Indigo
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withValues(alpha: 0.32),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -15,
            bottom: -20,
            child: Opacity(
              opacity: 0.16,
              child: Image.asset(
                'assets/images/app_logo.png',
                width: isTablet ? 190 : 145,
                height: isTablet ? 190 : 145,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      color: Colors.amberAccent,
                      size: 13,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'PORTAL BELAJAR MAHASISWA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Temukan Referensi &\nKelola Catatan Belajarmu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 28 : 22,
                  height: 1.2,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Akses ribuan referensi Open Library dan susun catatan belajarmu dengan rapi dalam satu tempat.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.88),
                  fontSize: 12,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ExplorePage(),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF3730A3),
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 11,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.travel_explore_rounded, size: 18),
                    label: const Text(
                      'Jelajahi Buku',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddNotePage(),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.16),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.35),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 11,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.edit_note_rounded, size: 19),
                    label: const Text(
                      'Catatan Baru',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // 4. QUICK ACTIONS
  // ==============================================================

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      _QuickAction(
        title: 'Cari Buku',
        subtitle: 'Katalog API',
        icon: Icons.search_rounded,
        accentColor: const Color(0xFF4F46E5),
        bgColor: const Color(0xFFEEF2FF),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ExplorePage()),
          );
        },
      ),
      _QuickAction(
        title: 'Tersimpan',
        subtitle: 'Buku favorit',
        icon: Icons.bookmark_rounded,
        accentColor: const Color(0xFFE11D48),
        bgColor: const Color(0xFFFFF1F2),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SavedPage()),
          );
        },
      ),
      _QuickAction(
        title: 'Catatan Saya',
        subtitle: 'Kelola rangkuman',
        icon: Icons.edit_note_rounded,
        accentColor: const Color(0xFFD97706),
        bgColor: const Color(0xFFFFFBEB),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotesPage()),
          );
        },
      ),
      _QuickAction(
        title: 'Buat Catatan',
        subtitle: 'Form baru',
        icon: Icons.add_circle_outline_rounded,
        accentColor: const Color(0xFF0D9488),
        bgColor: const Color(0xFFF0FDFA),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNotePage()),
          );
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Menu Navigasi Cepat',
          subtitle: 'Akses langsung ke setiap fitur utama StudyMate',
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            for (int index = 0; index < actions.length; index++) ...[
              if (index > 0) const SizedBox(width: 10),
              Expanded(child: _QuickActionCard(action: actions[index])),
            ],
          ],
        ),
      ],
    );
  }

  // ==============================================================
  // 5. STATISTICS
  // ==============================================================

  Widget _buildStatistics(BuildContext context, bool isTablet) {
    final savedCount = context
        .watch<StudyProvider>()
        .savedMaterials
        .length
        .toString();

    final noteCount = context.watch<NoteProvider>().notes.length.toString();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _MiniStatistic(
              icon: Icons.bookmark_added_rounded,
              iconColor: const Color(0xFFE11D48),
              bgColor: const Color(0xFFFFF1F2),
              value: savedCount,
              label: 'Buku Tersimpan',
            ),
          ),
          Container(
            width: 1,
            height: 42,
            color: Colors.grey.shade200,
          ),
          Expanded(
            child: _MiniStatistic(
              icon: Icons.note_alt_rounded,
              iconColor: const Color(0xFF4F46E5),
              bgColor: const Color(0xFFEEF2FF),
              value: noteCount,
              label: 'Catatan Belajar',
            ),
          ),
          if (isTablet) ...[
            Container(
              width: 1,
              height: 42,
              color: Colors.grey.shade200,
            ),
            const Expanded(
              child: _MiniStatistic(
                icon: Icons.cloud_done_rounded,
                iconColor: Color(0xFF0D9488),
                bgColor: Color(0xFFF0FDFA),
                value: 'Cloud',
                label: 'Supabase Sync',
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ==============================================================
  // 6. RECENT NOTES SECTION (DATA LIVE DARI SUPABASE)
  // ==============================================================

  Widget _buildRecentNotesSection(BuildContext context) {
    final noteProvider = context.watch<NoteProvider>();
    final notes = noteProvider.notes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Catatan Belajar Terkini',
          subtitle: 'Catatan dan rangkuman yang tersimpan di database',
          onSeeAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotesPage()),
            );
          },
        ),
        const SizedBox(height: 14),
        if (notes.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.edit_note_rounded,
                    color: Color(0xFF4F46E5),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Belum Ada Catatan',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Yuk buat catatan atau rangkuman materi pertamamu!',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton.tonal(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddNotePage(),
                      ),
                    );
                  },
                  child: const Text('Buat'),
                ),
              ],
            ),
          )
        else
          Column(
            children: notes.take(2).map((note) {
              return _RecentNoteItemCard(
                note: note,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditNotePage(note: note),
                    ),
                  );
                },
              );
            }).toList(),
          ),
      ],
    );
  }

  // ==============================================================
  // 7. SAVED REFERENCES PREVIEW (DATA LIVE DARI SUPABASE)
  // ==============================================================

  Widget _buildSavedReferencesPreview(BuildContext context) {
    final studyProvider = context.watch<StudyProvider>();
    final savedMaterials = studyProvider.savedMaterials;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Referensi Tersimpan',
          subtitle: 'Daftar buku yang sudah kamu bookmark',
          onSeeAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SavedPage()),
            );
          },
        ),
        const SizedBox(height: 14),
        if (savedMaterials.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.bookmark_border_rounded,
                    color: Color(0xFFE11D48),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Belum Ada Buku Tersimpan',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Cari buku di Explore, lalu tekan ikon bookmark untuk menyimpannya.',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton.tonal(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ExplorePage(),
                      ),
                    );
                  },
                  child: const Text('Cari'),
                ),
              ],
            ),
          )
        else
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              clipBehavior: Clip.none,
              padding: const EdgeInsets.only(right: 4),
              itemCount: savedMaterials.take(5).length,
              separatorBuilder: (_, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final material = savedMaterials[index];
                return _SavedBookMiniCard(
                  material: material,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StudyDetailPage(material: material),
                      ),
                    );
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  // ==============================================================
  // 8. CATEGORIES SECTION (KLIK LANGSUNG CARI KE EXPLORE)
  // ==============================================================

  Widget _buildCategorySection(BuildContext context, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Eksplorasi Topik Kuliah',
          subtitle: 'Pilih topik untuk langsung mencari buku di Open Library',
        ),
        const SizedBox(height: 15),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isTablet ? 4 : 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: isTablet ? 1.15 : 1.08,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];

            return _CategoryCard(
              title: category['title'] as String,
              description: category['description'] as String,
              icon: category['icon'] as IconData,
              color: category['color'] as Color,
              bgColor: category['bg'] as Color,
              index: index,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExplorePage(
                      initialQuery: category['query'] as String,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  // ==============================================================
  // 9. STUDY TIP
  // ==============================================================

  Widget _buildStudyTip(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips Belajar Efektif 💡',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: Color(0xFF92400E),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Simpan buku referensi penting ke menu "Saved", lalu catat poin kuncinya di menu "Notes" dengan prioritas High untuk memudahkan persiapan ujian UTS!',
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.5,
                    color: Color(0xFF78350F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// COMPONENT WIDGETS
// ================================================================

class _QuickAction {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final Color bgColor;
  final VoidCallback onTap;

  const _QuickAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.bgColor,
    required this.onTap,
  });
}

class _QuickActionCard extends StatelessWidget {
  final _QuickAction action;

  const _QuickActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: action.bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(action.icon, color: action.accentColor, size: 20),
              ),
              const SizedBox(height: 10),
              Text(
                action.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                action.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniStatistic extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String value;
  final String label;

  const _MiniStatistic({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecentNoteItemCard extends StatelessWidget {
  final StudyNote note;
  final VoidCallback onTap;

  const _RecentNoteItemCard({
    required this.note,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color priorityColor = const Color(0xFFD97706);
    if (note.priority == 'High') {
      priorityColor = const Color(0xFFE11D48);
    } else if (note.priority == 'Low') {
      priorityColor = const Color(0xFF0D9488);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: priorityColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              note.priority,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: priorityColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            note.category,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        note.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        note.content,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SavedBookMiniCard extends StatelessWidget {
  final StudyMaterial material;
  final VoidCallback onTap;

  const _SavedBookMiniCard({
    required this.material,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: material.coverUrl != null
                      ? Image.network(
                          material.coverUrl!,
                          width: 50,
                          height: 75,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 50,
                            height: 75,
                            color: const Color(0xFFEEF2FF),
                            child: const Icon(
                              Icons.menu_book_rounded,
                              color: Color(0xFF4F46E5),
                              size: 24,
                            ),
                          ),
                        )
                      : Container(
                          width: 50,
                          height: 75,
                          color: const Color(0xFFEEF2FF),
                          child: const Icon(
                            Icons.menu_book_rounded,
                            color: Color(0xFF4F46E5),
                            size: 24,
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        material.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        material.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final int index;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '0${index + 1}',
                      style: TextStyle(
                        color: color,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
