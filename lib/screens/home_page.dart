import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/note_provider.dart';
import '../providers/study_provider.dart';
import '../widgets/section_header.dart';
import 'explore_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<Map<String, dynamic>> categories = [
    {
      'title': 'Programming',
      'description': 'Code & Development',
      'icon': Icons.code_rounded,
    },
    {
      'title': 'Algorithm',
      'description': 'Logic & Problem Solving',
      'icon': Icons.account_tree_rounded,
    },
    {
      'title': 'Database',
      'description': 'Data & SQL',
      'icon': Icons.storage_rounded,
    },
    {
      'title': 'Design',
      'description': 'UI & Visual',
      'icon': Icons.palette_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 700;
            final horizontalPadding = isTablet ? 40.0 : 20.0;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                22,
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
                      const SizedBox(height: 24),
                      _buildHero(context, isTablet),
                      const SizedBox(height: 22),
                      _buildQuickActions(context, isTablet),
                      const SizedBox(height: 30),
                      _buildStatistics(context, isTablet),
                      const SizedBox(height: 34),
                      _buildCategorySection(context, isTablet),
                      const SizedBox(height: 34),
                      _buildRecommendedSection(context, isTablet),
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

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good day, Student 👋',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'What would you like to learn today?',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
          ),
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.school_rounded,
            color: colorScheme.primary,
            size: 25,
          ),
        ),
      ],
    );
  }

  Widget _buildHero(BuildContext context, bool isTablet) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 30 : 23),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.primary, const Color(0xFF7079C9)],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.22),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Text(
                    'YOUR LEARNING SPACE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Learn smarter.\nGrow every day.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 30 : 25,
                    height: 1.12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: 11),
                Text(
                  'Discover references, save what matters, and organize your learning journey.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.84),
                    fontSize: 12.5,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ExplorePage()),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 11,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.explore_rounded, size: 18),
                  label: const Text(
                    'Start Exploring',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          if (isTablet) ...[
            const SizedBox(width: 25),
            _buildHeroIllustration(context),
          ],
        ],
      ),
    );
  }

  Widget _buildHeroIllustration(BuildContext context) {
    return Container(
      width: 145,
      height: 145,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: const Center(
        child: Icon(Icons.auto_stories_rounded, color: Colors.white, size: 68),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isTablet) {
    final actions = [
      _QuickAction(
        title: 'Explore',
        subtitle: 'Find materials',
        icon: Icons.search_rounded,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ExplorePage()),
          );
        },
      ),
      _QuickAction(
        title: 'Saved',
        subtitle: 'Your references',
        icon: Icons.bookmark_rounded,
        onTap: () {},
      ),
      _QuickAction(
        title: 'Notes',
        subtitle: 'Study notes',
        icon: Icons.edit_note_rounded,
        onTap: () {},
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Quick Access',
          subtitle: 'Jump back into your learning',
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

  Widget _buildStatistics(BuildContext context, bool isTablet) {
    final savedCount = context
        .watch<StudyProvider>()
        .savedMaterials
        .length
        .toString();

    final noteCount = context.watch<NoteProvider>().notes.length.toString();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: _MiniStatistic(
              icon: Icons.bookmark_rounded,
              value: savedCount,
              label: 'Saved references',
            ),
          ),
          Container(width: 1, height: 42, color: Colors.grey.shade200),
          Expanded(
            child: _MiniStatistic(
              icon: Icons.note_alt_rounded,
              value: noteCount,
              label: 'Study notes',
            ),
          ),
          if (isTablet) ...[
            Container(width: 1, height: 42, color: Colors.grey.shade200),
            const Expanded(
              child: _MiniStatistic(
                icon: Icons.local_fire_department_rounded,
                value: 'Keep',
                label: 'Your study streak',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Explore Categories',
          subtitle: 'Choose a topic and start learning',
        ),
        const SizedBox(height: 15),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isTablet ? 4 : 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: isTablet ? 1.1 : 1.03,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];

            return _CategoryCard(
              title: category['title'] as String,
              description: category['description'] as String,
              icon: category['icon'] as IconData,
              index: index,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ExplorePage()),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecommendedSection(BuildContext context, bool isTablet) {
    final recommendations = [
      _Recommendation(
        title: 'Programming Fundamentals',
        subtitle: 'Start with the basics of programming',
        icon: Icons.code_rounded,
      ),
      _Recommendation(
        title: 'Algorithm & Logic',
        subtitle: 'Build stronger problem-solving skills',
        icon: Icons.account_tree_rounded,
      ),
      _Recommendation(
        title: 'Database Systems',
        subtitle: 'Understand data and SQL concepts',
        icon: Icons.storage_rounded,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Recommended for You',
          subtitle: 'References to support your study',
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: isTablet ? 190 : 175,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: recommendations.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _RecommendationCard(
                recommendation: recommendations[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ExplorePage()),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStudyTip(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.10)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Study Tip',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
                SizedBox(height: 5),
                Text(
                  'Save useful references and create short notes to make your next study session easier.',
                  style: TextStyle(fontSize: 12, height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
}

class _QuickActionCard extends StatelessWidget {
  final _QuickAction action;

  const _QuickActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(action.icon, color: colorScheme.primary, size: 20),
              ),
              const SizedBox(height: 12),
              Text(
                action.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                action.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
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
  final String value;
  final String label;

  const _MiniStatistic({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: colorScheme.primary, size: 19),
        ),
        const SizedBox(width: 9),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 9.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final int index;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(21),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(21),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: colorScheme.primary, size: 23),
              ),
              const Spacer(),
              Text(
                '0${index + 1}',
                style: TextStyle(
                  color: colorScheme.primary.withValues(alpha: 0.45),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 9.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Recommendation {
  final String title;
  final String subtitle;
  final IconData icon;

  const _Recommendation({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class _RecommendationCard extends StatelessWidget {
  final _Recommendation recommendation;
  final VoidCallback onTap;

  const _RecommendationCard({
    required this.recommendation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 270,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(21),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        recommendation.icon,
                        color: colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_outward_rounded,
                      color: Colors.grey.shade400,
                      size: 19,
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  recommendation.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  recommendation.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.menu_book_outlined,
                      size: 14,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Learning reference',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
