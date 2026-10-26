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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    context.read<StudyProvider>().searchMaterials(_searchController.text);
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<StudyProvider>().clearSearch();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 800;

            return Consumer<StudyProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 40 : 16,
                        vertical: 16,
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
                          hintText: 'Cari buku atau materi...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: _clearSearch,
                                  icon: const Icon(Icons.clear),
                                  tooltip: 'Hapus pencarian',
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
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

  Widget _buildContent(
    BuildContext context,
    StudyProvider provider,
    bool isWide,
  ) {
    if (provider.isLoading) {
      return const LoadingWidget(message: 'Memuat referensi...');
    }

    if (provider.error != null) {
      return ErrorStateWidget(message: provider.error!, onRetry: _search);
    }

    if (provider.query.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.menu_book_outlined,
        title: 'Find Your Learning References',
        message:
            'Search for books and learning materials using keywords '
            'such as Python, Algorithm, Database, or Design.',
      );
    }

    if (provider.materials.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.search_off_outlined,
        title: 'No References Found',
        message: 'We could not find results for "${provider.query}".',
      );
    }

    return _buildResults(context, provider.materials, isWide, provider.query);
  }

  Widget _buildResults(
    BuildContext context,
    List<StudyMaterial> materials,
    bool isWide,
    String query,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 40 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hasil pencarian untuk "$query"',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: isWide
                ? GridView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.35,
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
                    padding: const EdgeInsets.only(bottom: 24),
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

class _MaterialListCard extends StatelessWidget {
  final StudyMaterial material;
  final VoidCallback onTap;

  const _MaterialListCard({required this.material, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CoverImage(url: material.coverUrl, width: 80, height: 110),
              const SizedBox(width: 16),
              Expanded(child: _MaterialInformation(material: material)),
              const Icon(Icons.chevron_right),
            ],
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
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _CoverImage(url: material.coverUrl, width: 90, height: 120),
              const SizedBox(width: 16),
              Expanded(child: _MaterialInformation(material: material)),
              const Icon(Icons.chevron_right),
            ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          material.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(material.author, maxLines: 2, overflow: TextOverflow.ellipsis),
        if (material.publishYear != null) ...[
          const SizedBox(height: 4),
          Text(
            material.publishYear.toString(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: 8),
        Chip(
          label: Text(material.source),
          visualDensity: VisualDensity.compact,
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
    if (url == null || url!.isEmpty) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: const Icon(Icons.menu_book_outlined, size: 36),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        url!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Icon(Icons.broken_image_outlined, size: 36),
          );
        },
      ),
    );
  }
}
