import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/study_material.dart';
import '../providers/study_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/empty_state_widget.dart';
import 'study_detail_page.dart';

class ExplorePage extends StatefulWidget {
  final String? initialQuery;

  const ExplorePage({super.key, this.initialQuery});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();

  final List<_ExploreCategory> _categories = const [
    _ExploreCategory(
      title: 'Programming',
      query: 'Programming',
      description: 'Flutter, Dart, Python & Web',
      icon: Icons.code_rounded,
      color: Color(0xFF4F46E5), // Indigo
      bg: Color(0xFFEEF2FF),
    ),
    _ExploreCategory(
      title: 'Algorithm',
      query: 'Algorithm',
      description: 'Logika & Problem Solving',
      icon: Icons.account_tree_rounded,
      color: Color(0xFF0D9488), // Teal
      bg: Color(0xFFF0FDFA),
    ),
    _ExploreCategory(
      title: 'Database',
      query: 'Database',
      description: 'SQL, Supabase & Data Modeling',
      icon: Icons.storage_rounded,
      color: Color(0xFFD97706), // Amber
      bg: Color(0xFFFFFBEB),
    ),
    _ExploreCategory(
      title: 'Design UI/UX',
      query: 'Design',
      description: 'Material 3 & Visual Design',
      icon: Icons.palette_rounded,
      color: Color(0xFF9333EA), // Purple
      bg: Color(0xFFFAF5FF),
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _searchController.text = widget.initialQuery!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<StudyProvider>().searchMaterials(widget.initialQuery!);
        }
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    FocusScope.of(context).unfocus();
    context.read<StudyProvider>().searchMaterials(_searchController.text);
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<StudyProvider>().clearSearch();
    setState(() {});
  }

  void _searchCategory(String categoryQuery) {
    _searchController.text = categoryQuery;
    _search();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FD),
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(3),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/app_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Eksplorasi Katalog',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Temukan ribuan referensi & buku kuliah',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 800;

            return Consumer<StudyProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: [
                    _buildSearchSection(context, provider, isWide),
                    Expanded(child: _buildContent(context, provider, isWide)),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchSection(
    BuildContext context,
    StudyProvider provider,
    bool isWide,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(isWide ? 40 : 20, 10, isWide ? 40 : 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.035),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onChanged: (_) {
                setState(() {});
              },
              onSubmitted: (_) {
                _search();
              },
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
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: _clearSearch,
                        tooltip: 'Hapus pencarian',
                        icon: Icon(
                          Icons.close_rounded,
                          color: Colors.grey.shade500,
                          size: 20,
                        ),
                      )
                    : IconButton(
                        onPressed: _search,
                        tooltip: 'Cari di Open Library',
                        icon: Icon(
                          Icons.arrow_forward_rounded,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                      ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          if (provider.query.isEmpty) ...[
            Row(
              children: [
                const Icon(
                  Icons.local_fire_department_rounded,
                  size: 15,
                  color: Color(0xFFD97706),
                ),
                const SizedBox(width: 6),
                Text(
                  'Topik Populer',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 9),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                clipBehavior: Clip.none,
                padding: const EdgeInsets.only(right: 4),
                itemCount: _categories.length,
                separatorBuilder: (_, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = _categories[index];

                  return _TopicChip(
                    category: category,
                    onTap: () {
                      _searchCategory(category.query);
                    },
                  );
                },
              ),
            ),
          ] else ...[
            Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  'Mencari di katalog Open Library...',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11.5),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    StudyProvider provider,
    bool isWide,
  ) {
    if (provider.isLoading) {
      return const LoadingWidget(message: 'Mencari referensi di Open Library...');
    }

    if (provider.error != null) {
      return ErrorStateWidget(message: provider.error!, onRetry: _search);
    }

    if (provider.query.isEmpty) {
      return _buildExploreEmpty(context, isWide);
    }

    if (provider.materials.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.search_off_rounded,
        title: 'Referensi Tidak Ditemukan',
        message:
            'Tidak ada buku yang cocok dengan "${provider.query}". '
            'Coba gunakan kata kunci lain atau periksa ejaan.',
      );
    }

    return _buildResults(context, provider.materials, isWide, provider.query);
  }

  Widget _buildExploreEmpty(BuildContext context, bool isWide) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(isWide ? 40 : 20, 10, isWide ? 40 : 20, 30),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isWide ? 30 : 22),
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
                      color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
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
                          width: isWide ? 190 : 140,
                          height: isWide ? 190 : 140,
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
                                Icons.travel_explore_rounded,
                                color: Colors.amberAccent,
                                size: 13,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'KATALOG TERBUKA OPEN LIBRARY',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Mau Cari Referensi\nKuliah Apa Hari Ini?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isWide ? 28 : 22,
                            height: 1.2,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Akses ribuan buku dan materi belajar gratis langsung dari Open Library untuk persiapan tugas, proyek, dan ujian.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.88),
                            fontSize: 12,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Jelajahi Berdasarkan Topik',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Pilih bidang studi yang ingin kamu dalami atau cari',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isWide ? 4 : 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: isWide ? 1.35 : 1.05,
                ),
                itemBuilder: (context, index) {
                  final category = _categories[index];

                  return _CategoryExploreCard(
                    category: category,
                    onTap: () {
                      _searchCategory(category.query);
                    },
                  );
                },
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.22),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
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
                        Icons.tips_and_updates_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tips Pencarian Cepat 💡',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF92400E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Gunakan kata kunci spesifik seperti "Flutter", "Algoritma", "Database", atau nama penulis untuk hasil yang lebih relevan.',
                            style: TextStyle(
                              fontSize: 11.5,
                              height: 1.4,
                              color: Color(0xFF78350F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResults(
    BuildContext context,
    List<StudyMaterial> materials,
    bool isWide,
    String query,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 40 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hasil Pencarian',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Menampilkan materi untuk "$query"',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${materials.length} Buku Ditemukan',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: isWide
                ? GridView.builder(
                    padding: const EdgeInsets.only(bottom: 30),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.55,
                        ),
                    itemCount: materials.length,
                    itemBuilder: (context, index) {
                      final material = materials[index];

                      return _MaterialGridCard(
                        material: material,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  StudyDetailPage(material: material),
                            ),
                          );
                        },
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 30),
                    physics: const BouncingScrollPhysics(),
                    itemCount: materials.length,
                    itemBuilder: (context, index) {
                      final material = materials[index];

                      return _MaterialListCard(
                        material: material,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  StudyDetailPage(material: material),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _TopicChip extends StatelessWidget {
  final _ExploreCategory category;
  final VoidCallback onTap;

  const _TopicChip({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: category.bg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: category.color.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(category.icon, size: 14, color: category.color),
              const SizedBox(width: 6),
              Text(
                category.title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: category.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryExploreCard extends StatelessWidget {
  final _ExploreCategory category;
  final VoidCallback onTap;

  const _CategoryExploreCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
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
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: category.bg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      category.icon,
                      color: category.color,
                      size: 22,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: category.bg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Buku',
                      style: TextStyle(
                        color: category.color,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                category.title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                category.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 10.5,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Jelajahi',
                    style: TextStyle(
                      color: category.color,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 13,
                    color: category.color,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MaterialListCard extends StatelessWidget {
  final StudyMaterial material;
  final VoidCallback onTap;

  const _MaterialListCard({required this.material, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CoverImage(url: material.coverUrl, width: 78, height: 108),
                const SizedBox(width: 14),
                Expanded(child: _MaterialInformation(material: material)),
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Colors.grey.shade400,
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

class _MaterialGridCard extends StatelessWidget {
  final StudyMaterial material;
  final VoidCallback onTap;

  const _MaterialGridCard({required this.material, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(21),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                _CoverImage(url: material.coverUrl, width: 88, height: 118),
                const SizedBox(width: 15),
                Expanded(child: _MaterialInformation(material: material)),
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

class _MaterialInformation extends StatelessWidget {
  final StudyMaterial material;

  const _MaterialInformation({required this.material});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          material.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(
              Icons.person_outline_rounded,
              size: 13,
              color: Colors.grey.shade500,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                material.author,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: [
            if (material.publishYear != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 10.5,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      material.publishYear.toString(),
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.public_rounded,
                    size: 10.5,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    material.source,
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CoverImage extends StatelessWidget {
  final String? url;
  final double width;
  final double height;

  const _CoverImage({
    required this.url,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget imageContent;

    if (url == null || url!.isEmpty) {
      imageContent = Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primaryContainer,
              colorScheme.primary.withValues(alpha: 0.15),
            ],
          ),
        ),
        child: Center(
          child: Icon(
            Icons.menu_book_rounded,
            size: 32,
            color: colorScheme.primary,
          ),
        ),
      );
    } else {
      imageContent = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          url!,
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  Icons.broken_image_rounded,
                  size: 28,
                  color: colorScheme.primary,
                ),
              ),
            );
          },
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: imageContent,
    );
  }
}

class _ExploreCategory {
  final String title;
  final String query;
  final String description;
  final IconData icon;
  final Color color;
  final Color bg;

  const _ExploreCategory({
    required this.title,
    required this.query,
    required this.description,
    required this.icon,
    required this.color,
    required this.bg,
  });
}
