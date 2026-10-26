import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/study_material.dart';
import '../providers/study_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/empty_state_widget.dart';
import 'study_detail_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();

  final List<_ExploreCategory> _categories = const [
    _ExploreCategory(title: 'Programming', icon: Icons.code_rounded),
    _ExploreCategory(title: 'Algorithm', icon: Icons.account_tree_rounded),
    _ExploreCategory(title: 'Database', icon: Icons.storage_rounded),
    _ExploreCategory(title: 'Design', icon: Icons.palette_rounded),
  ];

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

  void _searchCategory(String category) {
    _searchController.text = category;
    _search();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8FC),
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 20,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Explore',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Discover something worth learning',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
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
      padding: EdgeInsets.fromLTRB(isWide ? 40 : 20, 12, isWide ? 40 : 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.035),
                  blurRadius: 15,
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
                hintText: 'Search books, topics, or materials...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                prefixIcon: Container(
                  margin: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    Icons.search_rounded,
                    color: colorScheme.primary,
                    size: 21,
                  ),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: _clearSearch,
                        tooltip: 'Clear search',
                        icon: Icon(
                          Icons.close_rounded,
                          color: Colors.grey.shade500,
                          size: 20,
                        ),
                      )
                    : IconButton(
                        onPressed: _search,
                        tooltip: 'Search',
                        icon: Icon(
                          Icons.arrow_forward_rounded,
                          color: colorScheme.primary,
                          size: 21,
                        ),
                      ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 17,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          if (provider.query.isEmpty) ...[
            Row(
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  size: 15,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Popular topics',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 9),
            SizedBox(
              height: 34,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = _categories[index];

                  return _TopicChip(
                    category: category,
                    onTap: () {
                      _searchCategory(category.title);
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
                  'Searching in StudyMate',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
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
      return const LoadingWidget(message: 'Finding learning references...');
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
        title: 'No References Found',
        message:
            'We could not find results for "${provider.query}". '
            'Try another keyword.',
      );
    }

    return _buildResults(context, provider.materials, isWide, provider.query);
  }

  Widget _buildExploreEmpty(BuildContext context, bool isWide) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
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
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [colorScheme.primary, const Color(0xFF7079C9)],
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'LEARNING LIBRARY',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 13),
                          const Text(
                            'What do you\nwant to learn?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              height: 1.12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 9),
                          Text(
                            'Search thousands of learning '
                            'references and discover new topics.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.82),
                              fontSize: 12,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isWide) ...[
                      const SizedBox(width: 20),
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.10),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.travel_explore_rounded,
                          color: Colors.white,
                          size: 58,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Browse by Topic',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 5),
              Text(
                'Start with a topic that interests you',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 15),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isWide ? 4 : 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: isWide ? 1.35 : 1.12,
                ),
                itemBuilder: (context, index) {
                  final category = _categories[index];

                  return _CategoryExploreCard(
                    category: category,
                    onTap: () {
                      _searchCategory(category.title);
                    },
                  );
                },
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(19),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.tips_and_updates_rounded,
                        color: Colors.white,
                        size: 21,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Search tip',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Use specific keywords such as '
                            'Python, Flutter, SQL, or Algorithm.',
                            style: TextStyle(
                              fontSize: 11,
                              height: 1.4,
                              color: Colors.grey.shade700,
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
                      'Search results',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Results for "$query"',
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
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${materials.length} found',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 10,
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
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(category.icon, size: 14, color: colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                category.title,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
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
    final colorScheme = Theme.of(context).colorScheme;

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
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  category.icon,
                  color: colorScheme.primary,
                  size: 22,
                ),
              ),
              const Spacer(),
              Text(
                category.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Explore',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 13,
                    color: colorScheme.primary,
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
        const SizedBox(height: 7),
        Text(
          material.author,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 11.5,
            height: 1.35,
          ),
        ),
        if (material.publishYear != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 12,
                color: Colors.grey.shade500,
              ),
              const SizedBox(width: 5),
              Text(
                material.publishYear.toString(),
                style: TextStyle(color: Colors.grey.shade500, fontSize: 10.5),
              ),
            ],
          ),
        ],
        const SizedBox(height: 9),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            material.source,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
            ),
          ),
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

    if (url == null || url!.isEmpty) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: colorScheme.primaryContainer,
        ),
        child: Icon(
          Icons.menu_book_rounded,
          size: 34,
          color: colorScheme.primary,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
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
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.broken_image_rounded,
              size: 30,
              color: colorScheme.primary,
            ),
          );
        },
      ),
    );
  }
}

class _ExploreCategory {
  final String title;
  final IconData icon;

  const _ExploreCategory({required this.title, required this.icon});
}
